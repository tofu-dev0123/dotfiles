---
description: Neovim設定ファイルの構成・スタイルを調査する
tools: Read, Glob
---

dotfiles リポジトリ内の Neovim 設定を調査し、以下の形式でまとめてメインエージェントに返す。

## 調査する内容

### 1. 導入済みプラグイン一覧
`nvim/lua/plugins/` 以下の全ファイルを Glob で取得し、各ファイルを Read して導入済みプラグイン名（`owner/repo` 形式）を抽出する。

### 2. lazy.nvim の記述スタイル
既存プラグインファイルを2〜3個 Read し、以下のスタイルを把握する：
- `return { ... }` の構造
- `opts` と `config` の使い分け
- キーマップの記述場所（`config` 内か `keys` テーブルか）
- コメントの書き方・言語（日本語 or 英語）

### 3. keymaps.lua の記述スタイル
`nvim/lua/core/keymaps.lua` を Read し、以下を把握する：
- `vim.keymap.set` の呼び出し形式
- `desc` フィールドの有無・書き方
- グループ分け・コメントの構造

### 4. README のプラグインテーブルフォーマット
`README.md` を Read し、プラグイン一覧テーブルの列構成・書式を把握する。

## 返答フォーマット

以下のMarkdown形式で返す：

```
## 導入済みプラグイン一覧
- `<owner/repo>` (`nvim/lua/plugins/<file>.lua`)
- ...

## lazy.nvim 記述スタイル
### 基本構造
\`\`\`lua
<実際のファイルから抜粋した典型的な記述例>
\`\`\`

### スタイルの特徴
- opts / config の使い分け: <説明>
- キーマップの記述場所: <説明>
- コメントの言語: <日本語 or 英語>

## keymaps.lua 記述スタイル
\`\`\`lua
<実際のファイルから抜粋した典型的な記述例>
\`\`\`

## README プラグインテーブルフォーマット
\`\`\`markdown
<実際のテーブル行の例>
\`\`\`
列構成: <列名の一覧>
```
