---
description: Neovimプラグインを追加する（Web検索→プラン作成）
argument-hint: <plugin-name or topic>
allowed-tools: WebSearch, WebFetch, Read, Glob, EnterPlanMode
---

引数 `$ARGUMENTS` を元に Neovim プラグインを追加するための実装プランを作成する。

## ステップ1: 引数の判定

`$ARGUMENTS` を確認し、以下のように処理を分岐する：

- `owner/repo` 形式（`/` を含む）または `.nvim` / `-nvim` を含む場合
  → **特定プラグインモード**としてステップ2Aへ進む
- それ以外（`ruby`, `python`, `go` など）
  → **テーマ検索モード**としてステップ2Bへ進む

## ステップ2A: 特定プラグインモード

`$ARGUMENTS` をプラグイン名として以下の情報をWeb検索・収集する：

- GitHubリポジトリのREADME（インストール方法・概要）
- lazy.nvim 形式の設定例
- デフォルト・推奨キーマップ
- 依存プラグイン

収集後、ステップ3へ進む。

## ステップ2B: テーマ検索モード

1. `"neovim $ARGUMENTS plugins recommended"` などで検索し、推奨プラグインを収集する
2. 用途別（LSP, formatter, syntax highlight, test runner など）に整理する
3. `nvim/lua/plugins/` 以下のファイル一覧を確認し、**未導入のプラグインのみ**をリストアップする
4. 以下のようなチェックリスト形式でユーザーに提示し、追加するプラグインを選んでもらう：

   ```
   以下のプラグインが見つかりました。追加するものを選んでください：

   - [ ] owner/repo-name — 説明（用途: LSP）
   - [ ] owner/repo-name — 説明（用途: formatter）
   - [ ] owner/repo-name — 説明（用途: syntax）
   ```

5. ユーザーが選択したプラグインそれぞれについてステップ2Aと同様に情報を収集する
6. 収集後、ステップ3へ進む

## ステップ3: 既存設定の確認

以下のファイルを読み取り、既存のフォーマット・構成を把握する：

- `nvim/lua/plugins/` 以下の既存プラグインファイル（構成の参考）
- `nvim/lua/core/keymaps.lua`（キーマップの記述スタイル確認）
- `README.md`（プラグイン一覧テーブルのフォーマット確認）

## ステップ4: プランの作成

`EnterPlanMode` を呼び出し、プランモードで以下の実装案を提示する。
プラグインが複数ある場合はプラグインごとにまとめる。

### 各プラグインに対して提示する内容

1. **`nvim/lua/plugins/<plugin-name>.lua` の新規作成内容**
   - 既存プラグインファイルのスタイルに合わせた lazy.nvim 形式
   - 依存プラグインがある場合は `dependencies` に記載
   - キーマップはプラグインファイル内の `config` 関数内に記述する

2. **`nvim/lua/core/keymaps.lua` への追記内容**（プラグイン固有でない汎用キーマップがある場合のみ）

3. **`README.md` のプラグイン一覧テーブルへの追記内容**
   - 既存のフォーマットに合わせて記載
