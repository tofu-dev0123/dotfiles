# dotfiles

macOS 向けの開発環境設定ファイル（dotfiles）を管理するリポジトリです。

## 管理対象ツール

- **Neovim** - テキストエディタ（Lazy.nvim, LSP, Treesitter, Neo-tree 等）
- **WezTerm** - ターミナルエミュレータ
- **Zsh** - シェル設定（エイリアス、fzf 連携等）

## リポジトリ構成

```
.
├── .config/
│   ├── nvim/
│   │   ├── init.lua
│   │   ├── lazy-lock.json
│   │   └── lua/
│   │       ├── core/
│   │       │   ├── keymaps.lua
│   │       │   └── options.lua
│   │       ├── plugins/
│   │       │   ├── init.lua
│   │       │   ├── cmp.lua
│   │       │   ├── colorscheme.lua
│   │       │   ├── lsp.lua
│   │       │   ├── lualine.lua
│   │       │   ├── neo-tree.lua
│   │       │   └── treesitter.lua
│   │       └── ui/
│   │           └── colorscheme.lua
│   └── wezterm/
│       ├── wezterm.lua
│       ├── appearance.lua
│       ├── keybinds.lua
│       └── tabs.lua
├── .zshrc
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

### 3. シンボリックリンクの作成

| リポジトリ | リンク先 |
|---|---|
| `.config/nvim/` | `~/.config/nvim` |
| `.config/wezterm/` | `~/.config/wezterm` |
| `.zshrc` | `~/.zshrc` |

```sh
ln -s ~/dev/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dev/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dev/dotfiles/.zshrc ~/.zshrc
```
