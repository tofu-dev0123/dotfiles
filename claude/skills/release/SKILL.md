---
name: release
description: リリース処理を自動化するスキル。developブランチからリリースブランチを作成し、mainへマージしてタグを付与してリモートにプッシュする。「リリースする」「リリース処理」「バージョンをリリース」「タグを打つ」「本番にリリース」などのフレーズが出たときは必ずこのスキルを使う。
tools: [Bash]
---

以下の手順でリリース処理を実行してください。

## 手順

### 1. 事前チェック

```bash
git status --porcelain
```

- 未コミットの変更があれば「未コミットの変更があります。コミットまたはスタッシュしてから再実行してください。」と表示して停止する

```bash
git fetch origin
git log origin/main..origin/develop --oneline
```

- develop と main に差分がなければ「develop に未リリースのコミットがありません。リリース不要です。」と表示して停止する

---

### 2. コミット分析とリリースレベルの提案

main..develop 間のコミットメッセージを取得して分析する：

```bash
git log origin/main..origin/develop --pretty=format:"%s"
```

以下のルールでリリースレベルを判断する：

- **major**: `BREAKING CHANGE` を含む、または `feat!:` / `fix!:` など `!` 付きのコミットがある
- **minor**: `feat:` のコミットがある（major でない場合）
- **patch**: `fix:` / `chore:` / `docs:` / `style:` / `refactor:` / `test:` のみ（major / minor でない場合）

コミット一覧と判断理由を提示し、以下の選択肢を表示する：

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

ユーザーが選択するまで待機する。「5」が選ばれた場合は停止する。

---

### 3. バージョン番号の決定

最新のタグを取得する：

```bash
git tag --sort=-v:refname | head -1
```

- タグが存在しない場合は `1.0.0` をリリースバージョンとする
- タグが存在する場合は `vX.Y.Z` または `X.Y.Z` 形式から数値を取り出し、選択されたリリースレベルに従ってインクリメントする
  - major: X+1.0.0
  - minor: X.Y+1.0
  - patch: X.Y.Z+1

決定したバージョンを表示してユーザーに確認を求める：

```
リリースバージョン: v1.2.0

このバージョンで進めますか？ [y/N]
```

`y` 以外が入力された場合は停止する。

---

### 4. リリースブランチの作成

```bash
git checkout develop
git pull origin develop
git checkout -b release/<バージョン>
git push origin release/<バージョン>
```

（例: `release/1.2.0`）

---

### 5. main へのマージ

```bash
git checkout main
git pull origin main
git merge --no-ff release/<バージョン> -m "release: v<バージョン>"
git push origin main
```

---

### 6. タグの付与とプッシュ

```bash
git tag v<バージョン>
git push origin v<バージョン>
```

---

### 7. 完了報告

以下の形式で完了を報告する：

```
リリース完了！

バージョン : v1.2.0
リリースブランチ: release/1.2.0
マージ先   : main
タグ       : v1.2.0
```
