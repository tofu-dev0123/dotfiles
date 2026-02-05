# dotfiles

macOS 向けの開発環境設定ファイル（dotfiles）を管理するリポジトリです。

## 管理対象ツール

- **Neovim** - テキストエディタ（Lazy.nvim, LSP, Treesitter, Neo-tree 等）
- **WezTerm** - ターミナルエミュレータ
- **Zsh** - シェル設定（エイリアス、fzf 連携等）

## Neovim プラグイン一覧

| プラグイン | 説明 | 設定ファイル |
|---|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | プラグインマネージャー | `init.lua` |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | スタート画面 | `plugins/alpha.lua` |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 補完エンジン | `plugins/cmp.lua` |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 設定 | `plugins/lsp.lua` |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト | `plugins/treesitter.lua` |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー | `plugins/telescope.lua` |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | ファイルエクスプローラー | `plugins/neo-tree.lua` |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン | `plugins/lualine.lua` |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | ターミナル | `plugins/toggleterm.lua` |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Markdown プレビュー | `plugins/markdown-preview.lua` |
| [tabset.nvim](https://github.com/FotiadisM/tabset.nvim) | ファイルタイプ別インデント | `plugins/tabset.lua` |

## リポジトリ構成

```
.
├── setup.sh              # セットアップスクリプト
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
│       │   ├── cmp.lua
│       │   ├── colorscheme.lua
│       │   ├── lsp.lua
│       │   ├── lualine.lua
│       │   ├── markdown-preview.lua
│       │   ├── neo-tree.lua
│       │   ├── tabset.lua
│       │   ├── telescope.lua
│       │   ├── toggleterm.lua
│       │   └── treesitter.lua
│       └── ui/
│           └── colorscheme.lua
├── wezterm/
│   ├── wezterm.lua
│   ├── appearance.lua
│   ├── keybinds.lua
│   └── tabs.lua
├── zsh/
│   └── .zshrc
└── README.md
```

## セットアップ

### 1. 必要なツールのインストール

[Homebrew](https://brew.sh/) を使用してインストールします。

```sh
brew install neovim eza fzf
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

**機能:**
- 既存のファイル/ディレクトリがある場合は `.backup.YYYYMMDD_HHMMSS` 形式で自動バックアップ
- `~/.config` ディレクトリがなければ自動作成
- bash / zsh どちらでも実行可能（POSIX 互換）
