# dotfiles

macOS 向けの開発環境設定ファイル（dotfiles）を管理するリポジトリです。

## 管理対象ツール

- **Neovim** - テキストエディタ（Lazy.nvim, LSP, Treesitter, Neo-tree 等）
- **WezTerm** - ターミナルエミュレータ
- **Zsh** - シェル設定（エイリアス、fzf 連携等）
- **Starship** - プロンプト設定
- **Claude Code** - AI コーディングアシスタント設定

## セットアップ方式

全 dotfiles は home-manager (Nix) で `$HOME` 配下に配置されます。
home-manager (Nix) への移行は段階的に進行中で、Phase 1 ([#51](https://github.com/tofu-dev0123/dotfiles/issues/51)) で全 dotfiles の symlink 化、Phase 2 ([#52](https://github.com/tofu-dev0123/dotfiles/issues/52)) で純 CLI ツール群の `home.packages` 集約、Phase 3 ([#53](https://github.com/tofu-dev0123/dotfiles/issues/53)) で zsh / git / starship を `programs.*` モジュールによる宣言的管理へ移行しました。

| ツール | 管理方式 |
|---|---|
| Zsh / Git / Starship | home-manager (`programs.*`) |
| Neovim / WezTerm / Claude Code | home-manager (`mkOutOfStoreSymlink`) |
| fzf | home-manager (`programs.fzf`)（zsh 統合自動有効化） |
| cosign / cowsay / eza / gh / jq / lazygit / luacheck / railway / shellcheck / stylua | home-manager (`home.packages`) |

`setup.sh` は Phase 3 で `PRE_MKDIRS` を `programs.zsh.history.path` に吸収させたため実質的な処理を持たず、Phase 4 ([#54](https://github.com/tofu-dev0123/dotfiles/issues/54)) で廃止予定です。

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

各パッケージディレクトリ内は `$HOME` の配置先をそのまま反映する **HOME ミラー型**で構成されています。
リポジトリ内のパスがそのまま symlink 先のパスになります。

```
.
├── flake.nix             # home-manager の flake 入口
├── flake.lock            # flake 依存ロック
├── home.nix              # home-manager 設定本体（imports でツール別モジュールを束ねる）
├── modules/
│   ├── dotfiles.nix      # mkOutOfStoreSymlink で配置する dotfiles 定義（Nix 非対応ツール）
│   ├── shell-env.nix     # XDG 環境変数 (home.sessionVariables) 集約
│   ├── zsh.nix           # programs.zsh 宣言（alias / history / sessionPath / profileExtra）
│   ├── git.nix           # programs.git 宣言（user.* / ignores）
│   └── starship.nix      # programs.starship 宣言（settings を Nix attrset で記述）
├── setup.sh              # 補助スクリプト（Phase 4 で廃止予定）
├── .luacheckrc           # Lua linter 設定
├── .github/
│   └── workflows/
│       └── ci.yml        # GitHub Actions CI
├── .claude/
│   ├── agents/           # プロジェクト固有エージェント
│   └── skills/           # プロジェクト固有スキル
├── nvim/
│   └── .config/nvim/             → ~/.config/nvim/
│       ├── init.lua
│       ├── lazy-lock.json
│       └── lua/
│           ├── core/             # keymaps.lua / options.lua
│           ├── plugins/          # 各プラグイン定義
│           └── ui/               # colorscheme.lua
├── wezterm/
│   └── .config/wezterm/          → ~/.config/wezterm/
│       ├── wezterm.lua
│       ├── appearance.lua
│       ├── keybinds.lua
│       └── tabs.lua
├── zsh/
│   └── zshrc-extra.sh            # programs.zsh.initContent から readFile で取り込み
└── claude/
    └── .claude/                  # ※ ~/.claude/ 全体は symlink せず、配下を個別にリンク
        ├── settings.json         → ~/.claude/settings.json
        ├── CLAUDE.md             → ~/.claude/CLAUDE.md
        ├── best-practice.md      # CLAUDE.md から @./ で参照
        ├── statusline-command.sh → ~/.claude/statusline-command.sh
        └── skills/               → ~/.claude/skills/
            ├── commit/
            ├── pr/
            ├── issue/
            ├── release/
            └── ...
```

### ミラー型構造の利点

- ディレクトリ構造が配置先を表現する（マッピング情報をスクリプトから排除）
- [home-manager](https://nix-community.github.io/home-manager/) で `xdg.configFile.<name>.source = ./<pkg>/.config/<name>` のように直接参照できる
- GNU Stow でも `stow nvim zsh git` だけで動作する構造

## セットアップ

全 dotfiles は home-manager 経由で配置されます。

### 0. 共通: 必要なツールのインストールとリポジトリ取得

[Homebrew](https://brew.sh/) を使用してインストールします。Brewfile を同梱しているので一括導入できます（`home.packages` で扱うものは除外済み）。

```sh
brew bundle install --file=Brewfile
```

リポジトリをクローン:

```sh
git clone https://github.com/<your-username>/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
```

### 1. Nix のインストール

[Determinate Systems Installer](https://determinate.systems/posts/determinate-nix-installer/) を推奨します。

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. 既存 symlink の退避（既存マシンの初回切替時のみ）

旧 `setup.sh` で張られた symlink や、旧 Phase の `mkOutOfStoreSymlink` で張られた symlink が残っていると home-manager が「foreign file」として失敗します。
**初回のみ手動で削除する**か、後述の `-b backup` オプションで退避してください。

手動削除する場合:

```sh
rm -f ~/.config/starship.toml
rm -rf ~/.config/nvim ~/.config/wezterm ~/.config/zsh ~/.config/git
rm -f ~/.zshenv
rm -f ~/.claude/settings.json ~/.claude/CLAUDE.md ~/.claude/statusline-command.sh
rm -rf ~/.claude/skills
```

> 上記はすべてリポジトリ実体への symlink なので削除しても dotfiles 本体には影響しません。

### 3. home-manager の実行

```sh
nix run home-manager/master -- switch --flake .#komusan -b backup
```

`-b backup` を付けると衝突したファイルを `<path>.backup` に退避してくれます。
退避された `.backup` ファイルは確認後に `./setup.sh --clean-backups` で削除可能です。

### 4. 通常運用

設定変更後は以下で適用します（`-b backup` は初回のみ必要）。

```sh
home-manager switch --flake .#komusan
```

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
