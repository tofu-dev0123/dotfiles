---
name: check
description: CIと同等のローカルチェックを実行する。shellcheck・luacheck・SKILL.md検証・symlink整合性を確認する。ユーザーが「チェック」「CI確認」「ローカルで確認」などと言ったときに使う
tools: [Bash]
---

以下のスクリプトを1回の Bash ツール呼び出しで実行してください。

```bash
total_failed=0

# 1. ShellCheck
if ! command -v shellcheck &>/dev/null; then
  shellcheck_result="[SKIP] ShellCheck"
else
  sh_files=$(find . -name '*.sh' -not -path './.git/*')
  if [ -z "$sh_files" ]; then
    shellcheck_result="[SKIP] ShellCheck (.sh ファイルなし)"
  elif echo "$sh_files" | xargs shellcheck 2>&1; then
    shellcheck_result="[PASS] ShellCheck"
  else
    shellcheck_result="[FAIL] ShellCheck"
    total_failed=$((total_failed + 1))
  fi
fi

# 2. Luacheck
if ! command -v luacheck &>/dev/null; then
  luacheck_result="[SKIP] Luacheck"
elif luacheck nvim/.config/nvim/lua/ 2>&1; then
  luacheck_result="[PASS] Luacheck"
else
  luacheck_result="[FAIL] Luacheck"
  total_failed=$((total_failed + 1))
fi

# 3. SKILL.md フロントマター検証
skill_failed=0
while IFS= read -r file; do
  if ! head -1 "$file" | grep -q '^---$'; then
    echo "  ERROR: フロントマターがありません: $file"
    skill_failed=1
    continue
  fi
  if ! awk '/^---$/{f++} f==1' "$file" | grep -q '^name:'; then
    echo "  ERROR: name フィールドがありません: $file"
    skill_failed=1
  fi
  if ! awk '/^---$/{f++} f==1' "$file" | grep -q '^description:'; then
    echo "  ERROR: description フィールドがありません: $file"
    skill_failed=1
  fi
done < <(find claude/.claude/skills -name 'SKILL.md')
if [ $skill_failed -eq 0 ]; then
  skill_result="[PASS] SKILL.md 検証"
else
  skill_result="[FAIL] SKILL.md 検証"
  total_failed=$((total_failed + 1))
fi

# 4. symlink 整合性確認 (modules/dotfiles.nix で参照しているパス)
symlink_failed=0
for path in nvim/.config/nvim wezterm/.config/wezterm claude/.claude/settings.json claude/.claude/skills claude/.claude/CLAUDE.md claude/.claude/statusline-command.sh; do
  if [ ! -e "$path" ]; then
    echo "  ERROR: 存在しません: $path"
    symlink_failed=1
  fi
done
if [ $symlink_failed -eq 0 ]; then
  symlink_result="[PASS] symlink 整合性"
else
  symlink_result="[FAIL] symlink 整合性"
  total_failed=$((total_failed + 1))
fi

# サマリ表示
echo "========================================"
echo "  ローカルチェック結果"
echo "========================================"
echo "$shellcheck_result"
echo "$luacheck_result"
echo "$skill_result"
echo "$symlink_result"
echo "========================================"
if [ $total_failed -eq 0 ]; then
  echo "すべてのチェックが通過しました ✓"
else
  echo "${total_failed} 件のチェックが失敗しました"
fi
```
