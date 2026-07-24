# dotfiles

macOS 向けの開発環境設定ファイル（dotfiles）を管理するリポジトリです。

## 管理対象ツール

- **Neovim** - テキストエディタ（Lazy.nvim, LSP, Treesitter, Neo-tree 等）
- **WezTerm** - ターミナルエミュレータ
- **AeroSpace** - i3 風タイル型ウィンドウマネージャ
- **Zsh** - シェル設定（エイリアス、fzf 連携、`pj` によるプロジェクトジャンプ等）
- **Starship** - プロンプト設定
- **Claude Code** - AI コーディングアシスタント設定

## セットアップ方式

全 dotfiles は home-manager (Nix) で `$HOME` 配下に配置されます。
home-manager (Nix) への移行は段階的に進行中で、Phase 1 ([#51](https://github.com/tofu-dev0123/dotfiles/issues/51)) で全 dotfiles の symlink 化、Phase 2 ([#52](https://github.com/tofu-dev0123/dotfiles/issues/52)) で純 CLI ツール群の `home.packages` 集約、Phase 3 ([#53](https://github.com/tofu-dev0123/dotfiles/issues/53)) で zsh / git / starship を `programs.*` モジュールによる宣言的管理へ移行、Phase 4 ([#54](https://github.com/tofu-dev0123/dotfiles/issues/54)) で `direnv + nix-direnv` 導入と `setup.sh` 廃止を行いました。

| ツール | 管理方式 |
|---|---|
| Zsh / Git / Starship / direnv | home-manager (`programs.*`) |
| Neovim / WezTerm / AeroSpace / Claude Code | home-manager (`mkOutOfStoreSymlink`) |
| fzf | home-manager (`programs.fzf`)（zsh 統合自動有効化） |
| cosign / cowsay / eza / fd / gh / jq / lazygit / lazydocker / luacheck / railway / serie / shellcheck / stylua | home-manager (`home.packages`) |
| GUI / Cask アプリ (1Password / WezTerm 等) | Homebrew (`Brewfile`) |
| プロジェクト固有のランタイム (ruby / node 等) | プロジェクト側 `flake.nix` + direnv（dotfiles では扱わない） |

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
| [peek.nvim](https://github.com/toppair/peek.nvim) | Markdown プレビュー（mermaid 対応・要 Deno） | `plugins/peek.lua` |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown をバッファ内でインラインレンダリング | `plugins/render-markdown.lua` |
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
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | カラースキーム（パステル） | `plugins/colorscheme.lua` |
| [everforest](https://github.com/sainnhe/everforest) | カラースキーム（緑系・低コントラスト） | `plugins/colorscheme.lua` |
| [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) | カラースキーム（GitHub 風） | `plugins/colorscheme.lua` |
| [gruvbox-material](https://github.com/sainnhe/gruvbox-material) | カラースキーム（暖色レトロ） | `plugins/colorscheme.lua` |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | カラースキーム（和風） | `plugins/colorscheme.lua` |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | カラースキーム（Fox ファミリー） | `plugins/colorscheme.lua` |
| [rose-pine/neovim](https://github.com/rose-pine/neovim) | カラースキーム（ロー彩度） | `plugins/colorscheme.lua` |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | カラースキーム（青系モダン） | `plugins/colorscheme.lua` |
| [vim-moonfly-colors](https://github.com/bluz71/vim-moonfly-colors) | カラースキーム（デフォルト） | `plugins/colorscheme.lua` |
| [vim-illuminate](https://github.com/RRethy/vim-illuminate) | カーソル下の単語をハイライト | `plugins/illuminate.lua` |
| [image.nvim](https://github.com/3rd/image.nvim) | バッファ内画像プレビュー（PNG/JPG/GIF/WebP）。`+`/`-` でズーム、`0` でリセット | `plugins/image.lua` |

## リポジトリ構成

各パッケージディレクトリ内は `$HOME` の配置先をそのまま反映する **HOME ミラー型**で構成されています。
リポジトリ内のパスがそのまま symlink 先のパスになります。

```
.
├── flake.nix             # home-manager の flake 入口
├── flake.lock            # flake 依存ロック
├── home.nix              # home-manager 設定本体（imports でツール別モジュールを束ねる）
├── nix/
│   └── modules/
│       └── shell-env.nix # XDG 環境変数 (home.sessionVariables) 集約（横断モジュール）
├── git/
│   └── git.nix           # programs.git 宣言（user.* / ignores）
├── starship/
│   └── starship.nix      # programs.starship 宣言（settings を Nix attrset で記述）
├── direnv/
│   └── direnv.nix        # programs.direnv 宣言（nix-direnv 連携で flake 自動評価）
├── docs/
│   ├── flake-template.md      # per-project flake.nix のテンプレート集（Ruby / Node 等）
│   └── nix-operation-guide.md # Nix / home-manager の日常運用ガイド
├── .luacheckrc           # Lua linter 設定
├── .github/
│   └── workflows/
│       └── ci.yml        # GitHub Actions CI
├── .claude/
│   ├── agents/           # プロジェクト固有エージェント
│   └── skills/           # プロジェクト固有スキル
├── nvim/
│   ├── nvim.nix                  # mkOutOfStoreSymlink で ~/.config/nvim を配置
│   └── .config/nvim/             → ~/.config/nvim/
│       ├── init.lua
│       ├── lazy-lock.json
│       └── lua/
│           ├── core/             # keymaps.lua / options.lua
│           ├── plugins/          # 各プラグイン定義
│           └── ui/               # colorscheme.lua
├── wezterm/
│   ├── wezterm.nix               # mkOutOfStoreSymlink で ~/.config/wezterm を配置
│   └── .config/wezterm/          → ~/.config/wezterm/
│       ├── wezterm.lua
│       ├── appearance.lua
│       ├── keybinds.lua
│       └── tabs.lua
├── aerospace/
│   ├── aerospace.nix             # mkOutOfStoreSymlink で ~/.config/aerospace を配置
│   └── .config/aerospace/        → ~/.config/aerospace/
│       └── aerospace.toml
├── zsh/
│   ├── zsh.nix                   # programs.zsh 宣言（alias / history / sessionPath / profileExtra）
│   └── zshrc-extra.sh            # programs.zsh.initContent から readFile で取り込み
├── scripts/
│   └── cleanup-caches.sh        # 開発ツールのキャッシュ一括クリーンアップ
└── claude/
    ├── claude.nix                # mkOutOfStoreSymlink で ~/.claude/ 配下を個別にリンク
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

[Homebrew](https://brew.sh/) を使用して GUI / Cask アプリをインストールします。
**`Brewfile` には GUI / Cask アプリのみを記載**し、CLI ツールは `home.packages` で管理する方針です。

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

旧 Phase の `mkOutOfStoreSymlink` で張られた symlink が残っていると home-manager が「foreign file」として失敗します。
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

マシン（macOS ユーザー名）に合わせて `.#<user>` を切り替えます。

```sh
# 個人 Mac
nix run home-manager/master -- switch --flake .#komusan -b backup

# 社用 Mac
nix run home-manager/master -- switch --flake .#masatokomukai -b backup
```

`-b backup` を付けると衝突したファイルを `<path>.backup` に退避してくれます。
退避された `.backup` ファイルは確認後に以下で削除できます。

```sh
find ~ -maxdepth 4 -name '*.backup.*' -print   # まず確認
find ~ -maxdepth 4 -name '*.backup.*' -exec rm -rf {} +
```

### 4. 通常運用

設定変更後は以下で適用します（`-b backup` は初回のみ必要）。

```sh
home-manager switch --flake .#komusan        # 個人 Mac
home-manager switch --flake .#masatokomukai  # 社用 Mac
```

## 複数マシン対応

`flake.nix` の `mkHome` ヘルパーで `home.username` / `home.homeDirectory` を注入しているため、`homeConfigurations` にユーザー名を追加するだけで新しいマシンに対応できます。

```nix
# flake.nix
homeConfigurations = {
  komusan = mkHome "komusan";
  masatokomukai = mkHome "masatokomukai";
  # 新規マシン追加時はここに 1 行足す
};
```

追加後は `home-manager switch --flake .#<新ユーザー名>` で適用します。`home.nix` 側はマシン非依存なので変更不要です。

個人/会社で分岐したい設定（git identity 等）は次節「複数 Git アカウントの切替」を参照してください。

## 複数 Git アカウントの切替

個人と会社のアカウントを使い分けるため、リポジトリの配置先に応じて `user.name` / `user.email` / SSH 鍵が自動切替されます（[#47](https://github.com/tofu-dev0123/dotfiles/issues/47)）。

### ディレクトリ規約

```
~/work/                  # 会社アカウントの集約ルート
├── mk-dt/               # 株式会社 MK-DT 用リポジトリ
└── <将来の会社>/         # 会社追加時はここに掘る
```

- `~/work/<会社名>/` 配下のリポジトリ → 会社用 config を `includeIf` で読み込む
- それ以外（`~/dev/` 等） → 個人用 config（`git/git.nix` の `settings.user`）がそのまま適用

`includeIf` ルールは `git/git.nix` で宣言。include 先ファイルの**中身**は個人情報を含むためリポジトリ非管理で、各マシンに手動配置します。

### ローカルで用意するファイル

#### `~/.config/git/config.mk-dt`（必須）

```ini
[user]
  name = <会社用 GitHub アカウント名>
  email = <会社メールアドレス>

[core]
  sshCommand = "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes"
```

- `~/work/mk-dt/` 配下で自動読込される
- `core.sshCommand` で会社用 SSH 鍵を強制使用（個人鍵が誤って使われる事故を防ぐ）

#### `~/.config/git/config.work-common`（任意）

複数会社で共通させたい設定があれば記述。不要なら作成しなくてよい（git は存在しない include 先を黙殺する）。

### SSH 鍵の前提

- 会社用鍵: `~/.ssh/id_ed25519`
- 個人用鍵: `~/.ssh/id_rsa`
- `~/.ssh/config` ではホストエイリアス（`github.com-work` 等）を使わず、素の `git@github.com:...` URL で運用。鍵の選択はディレクトリ位置に応じて `core.sshCommand` が決定する

### 動作確認

```sh
cd ~/work/mk-dt/<repo> && git config user.email   # 会社メールが返る
cd ~/dev/<repo>        && git config user.email   # 個人メールが返る
```

## プロジェクト単位のランタイム管理

言語ランタイム（ruby / node / python 等）は dotfiles では扱わず、**プロジェクトごとに `flake.nix` + `.envrc` を配置**して direnv で自動切替します。テンプレートは [`docs/flake-template.md`](./docs/flake-template.md) を参照してください。

日常的な運用フロー（パッケージ追加・flake 更新・トラブル切り分け等）は [`docs/nix-operation-guide.md`](./docs/nix-operation-guide.md) にまとめています。

新しいプロジェクトを始めるとき:

```sh
cd ~/dev/your-project
cp <template> flake.nix         # docs/flake-template.md を参考に作成
echo "use flake" > .envrc
direnv allow
```

`cd` するだけで該当プロジェクト用のランタイムが有効化されます。

## メンテナンススクリプト

`scripts/` 配下に手動実行のメンテナンス用ユーティリティを置いています。

| スクリプト | 用途 |
|---|---|
| `scripts/cleanup-caches.sh` | 開発ツール（npm / gradle / docker / cargo）のキャッシュを一括クリーンアップ。`--dry-run` で削除前のサイズだけ確認可能 |

```sh
./scripts/cleanup-caches.sh --dry-run   # 確認のみ
./scripts/cleanup-caches.sh             # 実際にクリーンアップ
```

導入されていないツールは自動でスキップされます。

## 補足: 個別ツールの方針

- **aws CLI キャッシュ** (`~/.aws/cli/`, `~/.aws/sso/`): aws CLI が `~/.aws` 直下を参照する仕様で XDG 化が困難なため `~/.aws` のまま維持する方針です（[#42](https://github.com/tofu-dev0123/dotfiles/issues/42) で議論し [#54](https://github.com/tofu-dev0123/dotfiles/issues/54) で確定）。

## CI

GitHub Actions で以下のチェックを自動実行します（PR・main push 時）。

| ジョブ | 内容 |
|---|---|
| ShellCheck | リポジトリ内のシェルスクリプト全般の静的解析 |
| Luacheck | `nvim/.config/nvim/lua/` 配下の Lua ファイル解析 |
| SKILL.md Validation | `claude/.claude/skills/**/SKILL.md` のフロントマター検証 |
| Symlink Source Check | 各ツール配下の `*.nix`（`nvim/nvim.nix` / `wezterm/wezterm.nix` / `aerospace/aerospace.nix` / `claude/claude.nix`）が参照するファイル・ディレクトリの存在確認 |

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
