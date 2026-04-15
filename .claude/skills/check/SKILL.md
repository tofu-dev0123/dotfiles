---
name: check
description: CIと同等のローカルチェックを実行する。shellcheck・luacheck・SKILL.md検証・symlink整合性を確認する。ユーザーが「チェック」「CI確認」「ローカルで確認」などと言ったときに使う
tools: [Bash]
---

以下の4つのチェックをすべて実行してください。1つが失敗しても残りを続行し、最後にサマリを表示してください。

## チェック内容

### 1. ShellCheck

```bash
if ! command -v shellcheck &>/dev/null; then
  echo "[SKIP] shellcheck がインストールされていません"
else
  shellcheck setup.sh && echo "[PASS] ShellCheck" || echo "[FAIL] ShellCheck"
fi
```

### 2. Luacheck

```bash
if ! command -v luacheck &>/dev/null; then
  echo "[SKIP] luacheck がインストールされていません"
else
  luacheck nvim/lua/ && echo "[PASS] Luacheck" || echo "[FAIL] Luacheck"
fi
```

### 3. SKILL.md フロントマター検証

```bash
failed=0
while IFS= read -r file; do
  if ! head -1 "$file" | grep -q '^---$'; then
    echo "  ERROR: フロントマターがありません: $file"
    failed=1
    continue
  fi
  if ! awk '/^---$/{f++} f==1' "$file" | grep -q '^name:'; then
    echo "  ERROR: name フィールドがありません: $file"
    failed=1
  fi
  if ! awk '/^---$/{f++} f==1' "$file" | grep -q '^description:'; then
    echo "  ERROR: description フィールドがありません: $file"
    failed=1
  fi
done < <(find claude/skills -name 'SKILL.md')
[ $failed -eq 0 ] && echo "[PASS] SKILL.md 検証" || echo "[FAIL] SKILL.md 検証"
```

### 4. symlink 整合性確認

```bash
failed=0
paths=(
  "nvim"
  "wezterm"
  "zsh/.zshrc"
  "starship/starship.toml"
  "claude/settings.json"
  "claude/skills"
  "claude/CLAUDE.md"
  "claude/statusline-command.sh"
)
for path in "${paths[@]}"; do
  if [ ! -e "$path" ]; then
    echo "  ERROR: 存在しません: $path"
    failed=1
  fi
done
[ $failed -eq 0 ] && echo "[PASS] symlink 整合性" || echo "[FAIL] symlink 整合性"
```

## 完了後

全チェック結果を以下の形式でまとめて表示してください：

```
========================================
  ローカルチェック結果
========================================
[PASS] ShellCheck
[PASS] Luacheck
[PASS] SKILL.md 検証
[PASS] symlink 整合性
========================================
すべてのチェックが通過しました ✓
```

FAILがある場合は「X 件のチェックが失敗しました」と表示してください。
