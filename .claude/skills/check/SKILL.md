---
name: check
description: CIと同等のローカルチェックを実行する。shellcheck・luacheck・SKILL.md検証・nixfmt・statix・home-manager build を確認する。ユーザーが「チェック」「CI確認」「ローカルで確認」などと言ったときに使う
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

# 4. nixfmt (RFC 166 公式フォーマッタ) で .nix を検証
nix_files=$(find . -name '*.nix' -not -path './.git/*' -not -path './result/*')
if ! command -v nixfmt &>/dev/null; then
  nixfmt_result="[SKIP] nixfmt"
elif [ -z "$nix_files" ]; then
  nixfmt_result="[SKIP] nixfmt (.nix ファイルなし)"
elif echo "$nix_files" | xargs nixfmt --check 2>&1; then
  nixfmt_result="[PASS] nixfmt"
else
  nixfmt_result="[FAIL] nixfmt (整形が必要: nixfmt **/*.nix)"
  total_failed=$((total_failed + 1))
fi

# 5. statix で Nix anti-pattern を検証
if ! command -v statix &>/dev/null; then
  statix_result="[SKIP] statix"
elif statix check . 2>&1; then
  statix_result="[PASS] statix"
else
  statix_result="[FAIL] statix (修正: statix fix .)"
  total_failed=$((total_failed + 1))
fi

# 6. home-manager build による flake/モジュール検証
#    symlink 整合性も home.file.*.source の評価で同時にチェックされる
if ! command -v home-manager &>/dev/null; then
  hm_result="[SKIP] home-manager build"
elif home-manager build --flake .#komusan 2>&1 >/dev/null; then
  hm_result="[PASS] home-manager build"
  rm -f result
else
  hm_result="[FAIL] home-manager build"
  total_failed=$((total_failed + 1))
fi

# サマリ表示
echo "========================================"
echo "  ローカルチェック結果"
echo "========================================"
echo "$shellcheck_result"
echo "$luacheck_result"
echo "$skill_result"
echo "$nixfmt_result"
echo "$statix_result"
echo "$hm_result"
echo "========================================"
if [ $total_failed -eq 0 ]; then
  echo "すべてのチェックが通過しました ✓"
else
  echo "${total_failed} 件のチェックが失敗しました"
fi
```
