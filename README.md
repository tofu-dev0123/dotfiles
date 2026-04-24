# dotfiles

macOS 向けの開発環境設定ファイル（dotfiles）を管理するリポジトリです。

## 管理対象ツール

- **Neovim** - テキストエディタ（Lazy.nvim, LSP, Treesitter, Neo-tree 等）
- **WezTerm** - ターミナルエミュレータ
- **Zsh** - シェル設定（エイリアス、fzf 連携等）
- **Starship** - プロンプト設定
- **Claude Code** - AI コーディングアシスタント設定

## Neovim プラグイン一覧

| プラグイン | 説明 | 設定ファイル |
|---|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | プラグインマネージャー | `init.lua` |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | スタート画面 | `plugins/alpha.lua` |
| [barbar.nvim](https://github.com/romgrk/barbar.nvim) | タブバー | `plugins/barbar.lua` |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 補完エンジン | `plugins/cmp.lua` |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | フォーマッター | `plugins/conform.lua` |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | デバッガー | `plugins/dap.lua` |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Git diff ビューワー | `plugins/diffview.lua` |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 設定 | `plugins/lsp.lua` |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン | `plugins/lualine.lua` |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Markdown プレビュー | `plugins/markdown-preview.lua` |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | ファイルエクスプローラー | `plugins/neo-tree.lua` |
| [vim-rails](https://github.com/tpope/vim-rails) | Rails サポート | `plugins/ruby.lua` |
| [vim-endwise](https://github.com/tpope/vim-endwise) | Ruby end 自動補完 | `plugins/ruby.lua` |
| [vim-test](https://github.com/vim-test/vim-test) | テスト実行 | `plugins/ruby.lua` |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | スニペットエンジン | `plugins/snippets.lua` |
| [swenv.nvim](https://github.com/AckslD/swenv.nvim) | Python 仮想環境切替 | `plugins/swenv.lua` |
| [tabset.nvim](https://github.com/FotiadisM/tabset.nvim) | ファイルタイプ別インデント | `plugins/tabset.lua` |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー | `plugins/telescope.lua` |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | ターミナル | `plugins/toggleterm.lua` |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト | `plugins/treesitter.lua` |
| [vim-moonfly-colors](https://github.com/bluz71/vim-moonfly-colors) | カラースキーム | `plugins/colorscheme.lua` |
| [vim-illuminate](https://github.com/RRethy/vim-illuminate) | カーソル下の単語をハイライト | `plugins/illuminate.lua` |

## リポジトリ構成

```
.
├── setup.sh              # セットアップスクリプト
├── .luacheckrc           # Lua linter 設定
├── .github/
│   └── workflows/
│       └── ci.yml        # GitHub Actions CI
├── .claude/
│   └── skills/           # プロジェクト固有スキル
├── nvim/
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
│       ├── core/
│       │   ├── keymaps.lua
│       │   └── options.lua
│       ├── plugins/
│       │   ├── init.lua
│       │   ├── alpha.lua
│       │   ├── ...
│       │   └── illuminate.lua
│       └── ui/
│           └── colorscheme.lua
├── wezterm/
│   ├── wezterm.lua
│   ├── appearance.lua
│   ├── keybinds.lua
│   └── tabs.lua
├── zsh/
│   └── .zshrc
├── starship/
│   └── starship.toml
└── claude/
    ├── settings.json
    ├── CLAUDE.md
    ├── statusline-command.sh
    └── skills/            # Claude Code カスタムスキル
        ├── commit/
        ├── pr/
        ├── issue/
        ├── release/
        └── ...
```

## セットアップ

### 1. 必要なツールのインストール

[Homebrew](https://brew.sh/) を使用してインストールします。

```sh
brew install neovim eza fzf starship
brew install --cask wezterm
```

### 2. リポジトリのクローン

```sh
git clone https://github.com/<your-username>/dotfiles.git ~/dev/dotfiles
```

### 3. セットアップスクリプトの実行

```sh
cd ~/dev/dotfiles
./setup.sh
```

セットアップスクリプトは以下を自動的に行います：

| ソース | リンク先 |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `wezterm/` | `~/.config/wezterm` |
| `zsh/.zshrc` | `~/.zshrc` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/skills` | `~/.claude/skills` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` |

**機能:**
- 既存のファイル/ディレクトリがある場合は `.backup.YYYYMMDD_HHMMSS` 形式で自動バックアップ
- `~/.config` ディレクトリがなければ自動作成
- bash / zsh どちらでも実行可能（POSIX 互換）

## CI

GitHub Actions で以下のチェックを自動実行します（PR・main push 時）。

| ジョブ | 内容 |
|---|---|
| ShellCheck | `setup.sh` の静的解析 |
| Luacheck | `nvim/lua/` 配下の Lua ファイル解析 |
| SKILL.md Validation | `claude/skills/**/SKILL.md` のフロントマター検証 |
| Symlink Source Check | `setup.sh` が参照するファイル・ディレクトリの存在確認 |

## Claude Code カスタムスキル

| スキル | 説明 |
|---|---|
| `/commit` | 差分を解析して日本語コミットメッセージを生成・実行 |
| `/pr [base-branch]` | PR を自動作成（タイトル・本文をコミットから自動生成） |
| `/issue [topic]` | GitHub Issue を作成（ヒアリング形式） |
| `/issues` | GitHub のオープン Issue を一覧表示・選択して詳細を確認（実装モードで feature/issue#&lt;番号&gt; ブランチを作成） |
| `/release` | リリース処理を自動化（ブランチ作成・マージ・タグ付与） |
| `/f-pr` | Forgejo リポジトリに PR を自動作成 |
| `/f-issue` | Forgejo リポジトリに Issue を作成 |
| `/update-readme` | プロジェクトを調査して README を更新 |
| `/setup-claude-md` | インタビュー形式で CLAUDE.md を対話的に作成 |
| `/check` | CI と同等のローカルチェックを実行 |
