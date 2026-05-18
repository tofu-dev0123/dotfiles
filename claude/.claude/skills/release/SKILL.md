---
name: release
description: リリース処理を自動化するスキル。develop から release ブランチを切って main への PR を作成 → マージ後にタグ付与 + develop へバックマージ。「リリースする」「リリース処理」「バージョンをリリース」「タグを打つ」「本番にリリース」などのフレーズが出たときは必ずこのスキルを使う。
tools: [Bash]
---

2 フェーズ式でリリースを進める。スキルが現在の git 状態を検出し、自動的に Phase 1 / Phase 2 のどちらかを実行する。

## フェーズ判定

実行時に以下を取得して状態を判定する:

```bash
git fetch origin main develop --tags --quiet

OPEN_PR=$(gh pr list --base main --state open --search "release: in:title" --json number,headRefName --jq '.[0]')
COMMITS_MAIN_AHEAD=$(git rev-list --count origin/develop..origin/main)
```

- **`$OPEN_PR` が非空** → 既に Phase 1 完了、PR がマージされるのを待つ状態。状況を表示して停止
- **`$COMMITS_MAIN_AHEAD > 0`** (main が develop より進んでいる) → Phase 2 (タグ付与 + develop へバックマージ)
- **その他** → Phase 1 (新規リリース)

---

## Phase 1: release ブランチ作成 + main への PR 作成

### 1. 事前チェック

```bash
git status --porcelain
```

未コミットの変更があれば「未コミットの変更があります。コミットまたはスタッシュしてから再実行してください。」と表示して停止。

```bash
git log origin/main..origin/develop --oneline
```

差分がなければ「develop に未リリースのコミットがありません。リリース不要です。」と表示して停止。

### 2. コミット分析とリリースレベル提案

```bash
git log origin/main..origin/develop --pretty=format:"%s"
```

判定ルール:

- **major**: `BREAKING CHANGE` を含む、または `feat!:` / `fix!:` など `!` 付きコミットがある
- **minor**: `feat:` のコミットがある（major でない場合）
- **patch**: `fix:` / `chore:` / `docs:` / `style:` / `refactor:` / `test:` のみ（major / minor でない場合）

コミット一覧と判断理由を提示して以下の選択肢を表示:

```
コミット分析結果:
- feat: ログイン機能を追加
- fix: パスワードバリデーションのバグを修正

判断: minor リリース（新機能 feat が含まれるため）

リリースレベルを選択してください:
1. このまま進む（minor）
2. major に変更
3. minor に変更
4. patch に変更
5. キャンセル
```

`5` または明示的なキャンセル指示で停止。

### 3. バージョン番号の決定

```bash
git tag --sort=-v:refname | head -1
```

- タグが無い場合: package.json の `version` を読み、それを初版とする（無ければ `0.1.0`）
- タグがある場合: `vX.Y.Z` または `X.Y.Z` 形式から数値を取り出し、選択されたレベルでインクリメント
  - major: X+1.0.0
  - minor: X.Y+1.0
  - patch: X.Y.Z+1

確認:

```
リリースバージョン: v1.2.0

このバージョンで進めますか？ [y/N]
```

`y` 以外で停止。

### 4. release ブランチ作成 + push

```bash
git checkout develop
git pull origin develop
git checkout -b release/v<バージョン>
git push -u origin release/v<バージョン>
```

`.husky/pre-push` が `release/*` を許可していない場合は `ALLOW_PROTECTED_PUSH=1` を付ける。

### 5. main への PR を作成

```bash
gh pr create \
  --base main \
  --head release/v<バージョン> \
  --title "release: v<バージョン>" \
  --body "$(cat <<'EOF'
## リリース範囲

(main..develop のコミット一覧)

## リリースレベル

(major / minor / patch とその根拠)

## マージ後

このスキル (`/release`) を再度実行するとタグ付与 + develop へのバックマージが自動実行される。

EOF
)"
```

### 6. 完了報告

```
Phase 1 完了

release ブランチ: release/v<バージョン>
PR             : <URL>

GitHub で PR をレビュー / マージしてください。
マージ後にこのスキルを再度実行すると、タグ付与 + develop バックマージが自動実行されます。
```

ここで停止する。

---

## Phase 2: タグ付与 + develop へバックマージ

`origin/main` が `origin/develop` より進んでいる状態で起動する。

### 1. バージョンの特定

`origin/main` の最新マージコミット (`gh pr list --base main --state merged --search "release: in:title" --limit 1 --json title --jq '.[0].title'` または `git log origin/main -1 --pretty=%s`) からバージョン番号 `v<X.Y.Z>` を抽出する。

不明な場合はユーザーに確認:

```
リリース対象のバージョンを入力してください (例: v1.2.0):
```

### 2. main を最新化してタグを付与

```bash
git checkout main
git pull --ff-only origin main
git tag v<バージョン>
git push origin v<バージョン>
```

タグが既に存在する場合は「タグ v<バージョン> は既に存在します。バックマージのみ続行しますか？ [y/N]」と確認。

### 3. develop へのバックマージ

```bash
git checkout develop
git pull --ff-only origin develop
git merge --no-ff main -m "chore: backmerge v<バージョン>"
ALLOW_PROTECTED_PUSH=1 git push origin develop
```

コンフリクトが発生したら **手動で解決** するようユーザーに指示して停止する (自動 abort しない)。

### 4. release ブランチを削除 (任意)

```bash
git push origin --delete release/v<バージョン> 2>/dev/null || true
git branch -D release/v<バージョン> 2>/dev/null || true
```

存在しなくてもエラーにしない。

### 5. 完了報告

```
リリース完了!

バージョン  : v<バージョン>
タグ        : v<バージョン> をプッシュ
main        : <短縮 SHA>
develop     : main から backmerge 済み
release/v<バージョン> ブランチ: 削除
```

---

## 禁止事項

- 破壊的 git 操作 (`git push --force`, `git reset --hard`, `git clean -f` 等) はユーザーの明示的指示なしに実行しない
- `--no-verify` で hook をスキップしない (失敗時は原因を直す)
- main / develop への直 push は `.husky/pre-push` で保護されている。`ALLOW_PROTECTED_PUSH=1` は本スキルが develop バックマージ時に使うのみ
- ユーザー確認待ちのプロンプトは飛ばさない
