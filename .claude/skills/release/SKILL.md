---
name: release
description: 昇格フロー（branch-flow.md）に沿ってリリースする。develop から上の段（staging / main）への昇格の PR を作り、main へのマージ後にタグ vX.Y.Z を打つ。release ブランチ・バックマージは使わない。「リリースする」「リリース処理」「バージョンをリリース」「タグを打つ」「本番にリリース」「検証環境に出す」「staging に上げる」と言われたときは必ずこのスキルを使う
---

# リリース

`.claude/rules/shared/branch-flow.md`（常に読み込まれている）の「昇格の順」に沿ってリリースを進める。

- flow-develop：`develop` → `main`
- flow-staging：`develop` → `staging` → `main`

実行するたびに、今の状態から次にやることを1つだけ判定して進める。何度実行しても安全なように、作業ツリーは触らない（checkout・merge・commit をしない）。PR のマージは人が行う。

## 守ること

- バージョンはファイルに書かない。正本は昇格の PR のタイトル（`release: vX.Y.Z`）とタグだけ
- タグを打つのはこのスキルだけ。打つのは `main` へのマージの後
- 守るブランチ（`develop`・`staging`・`main`）へは push しない（`protect-branch.sh` が止める）。push するのはタグだけ
- release ブランチを作らない。バックマージしない
- 破壊的な git 操作（`--force`・`reset --hard`・タグの削除や付け替え）をしない
- 確認を求める箇所は飛ばさない

## 1. 状態の判定

```bash
git fetch origin --tags --prune --quiet
```

上から順に確かめ、最初に当てはまったものを行う。

| # | 状態 | 確かめ方 | 次にやること |
|---|---|---|---|
| A | 昇格の PR が開いている | `gh pr list --state open --search "release: in:title" --json number,title,baseRefName,headRefName,url` が空でない | PR の URL を示し、「マージ後にもう一度 `/release` を実行する」と伝えて止まる |
| B | `main` に、タグの無い昇格がある | 下記「B の確かめ方」 | 2. タグを打つ |
| C | （flow-staging のみ）`staging` に、`main` へ未昇格の変更がある | `git log --oneline origin/main..origin/staging` が空でない | 3. staging から main へ昇格する |
| D | `develop` に、次の段へ未昇格の変更がある | `git log --oneline origin/<次の段>..origin/develop` が空でない（次の段は flow-develop なら `main`、flow-staging なら `staging`） | 4. develop から昇格する |
| — | どれでもない | | 「リリースするものがない」と伝えて止まる |

**B の確かめ方**

```bash
gh pr list --base main --state merged --search "release: in:title" --limit 1 \
  --json number,title,mergeCommit --jq '.[0]'
```

タイトルから `vX.Y.Z` を取り出し、`git tag --list vX.Y.Z` が空なら B に当たる。

**C と D が両方当たるとき（flow-staging）**：検証環境で見つけた修正を `develop` で直した場合など。次のどちらにするかをユーザーに聞く。

1. `staging` の内容を本番へ昇格する（3 へ）
2. `develop` の修正を `staging` へ追加で昇格する（4 へ。バージョンは `staging` に出ているものを引き継ぐ）

## 2. タグを打つ

1. B で見つけた PR のタイトルからバージョン、`mergeCommit.oid` からマージコミットを取る
2. 確認する：「`vX.Y.Z` を `<短縮 SHA>`（`main` の昇格マージ）に打ちます。よいですか？」
3. 打って push する

```bash
git tag vX.Y.Z <マージコミットの SHA>
git push origin refs/tags/vX.Y.Z
```

4. 完了を報告して終える

```
リリース完了
バージョン: vX.Y.Z
タグ      : <短縮 SHA> に付けて push 済み
```

## 3. staging から main へ昇格する（flow-staging）

1. バージョンを決める：`staging` へ昇格した最新の PR のタイトルから取る。新しく計算しない（検証環境と本番を同じバージョンにする）

```bash
gh pr list --base staging --state merged --search "release: in:title" --limit 1 --json title --jq '.[0].title'
```

2. `git tag --list vX.Y.Z` が空であることを確かめる。すでにあれば、止まって知らせる
3. 確認する：範囲（`git log --no-merges --pretty='%h %s' origin/main..origin/staging`）とバージョンを示す
4. PR を作る（本文は「5. PR の本文」）

```bash
gh pr create --base main --head staging --title "release: vX.Y.Z" --body-file <一時ファイル>
```

5. PR の URL を示し、「マージコミットを作る方法でマージし、マージ後にもう一度 `/release` を実行するとタグを打つ」と伝えて止まる

## 4. develop から昇格する

**バージョンを引き継ぐとき**（1 の「C と D が両方当たる」で 2 を選んだとき）：`staging` に出ているバージョンを使い、手順 4 へ進む。

**新しく決めるとき**：

1. 範囲を取る

```bash
git log --no-merges --pretty='%h %s' origin/<次の段>..origin/develop
```

2. コミットの type からリリースの大きさを提案する
   - **major**：`BREAKING CHANGE` を含む、または `feat!:` `fix!:` など `!` 付きがある
   - **minor**：`feat:` がある（major でないとき）
   - **patch**：それ以外（`fix:` `docs:` `refactor:` `chore:` `test:` など）

```
コミット分析結果:
- feat: ログイン機能を追加
- fix: パスワードの検証のバグを修正

判断: minor（feat が含まれるため）

1. このまま進む（minor）
2. major に変更
3. patch に変更
4. キャンセル
```

3. バージョンを計算する：最新のタグ（`git tag --list 'v*' --sort=-v:refname | head -1`）を選んだ大きさで上げる。タグが無ければ、初版のバージョンをユーザーに聞く（既定は `v0.1.0`）。確認する：「`vX.Y.Z` で進めますか？」

4. PR を作る（本文は「5. PR の本文」）

```bash
gh pr create --base <次の段> --head develop --title "release: vX.Y.Z" --body-file <一時ファイル>
```

5. PR の URL を示し、次を伝えて止まる
   - マージコミットを作る方法でマージする
   - flow-develop：マージ後にもう一度 `/release` を実行するとタグを打つ
   - flow-staging：検証環境で確かめたあと、もう一度 `/release` を実行すると `main` への昇格の PR を作る

## 5. PR の本文

一時ファイル（リポジトリの外）に書いて `--body-file` で渡す。

```markdown
## リリース範囲
<git log の一覧>

## リリースの大きさ
<major / minor / patch と、その根拠。引き継いだときは「staging の vX.Y.Z を引き継ぐ」>

## マージの方法
マージコミットを作る方法でマージする（squash / rebase にしない。次のリリースの範囲が壊れるため）。

## マージ後
`/release` をもう一度実行する（<タグを打つ / main への昇格の PR を作る>）。
```
