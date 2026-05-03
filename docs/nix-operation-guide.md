# Nix 運用ガイド

このリポジトリの Nix / home-manager 構成を日常的にどう使い、保守していくかをまとめたガイド。

## 1. 全体像 — どこで何を管理するのか

```
┌─────────────────────────────────────────────────────────┐
│ ① OS / GUI / Cask アプリ                                │
│   Homebrew (Brewfile)                                   │
│   ※ Phase 5 で nix-darwin に吸収予定                    │
├─────────────────────────────────────────────────────────┤
│ ② ユーザ環境（シェル・エディタ・CLI ツール・direnv）    │
│   home-manager (このリポジトリ)                         │
│   = flake.nix + home.nix + modules/                     │
├─────────────────────────────────────────────────────────┤
│ ③ プロジェクト固有のランタイム / ライブラリ             │
│   per-project flake.nix + .envrc + direnv               │
└─────────────────────────────────────────────────────────┘
```

**鉄則**: 各層は責務を越境しない。例えば「Rails プロジェクトの ruby は dotfiles に書かない」「fzf は Brewfile に書かない」。

## 2. 日常運用フロー

### A. ユーザ環境を変えたいとき（②に手を加える）

新しい CLI ツール `ripgrep` を入れたい場合:

```sh
# 1. home.nix を編集
$EDITOR ~/dev/dotfiles/home.nix
#   home.packages の中に  ripgrep  を 1 行足す

# 2. 適用
home-manager switch --flake ~/dev/dotfiles#komusan

# 3. 動作確認
which ripgrep
```

zsh のエイリアスを足したい場合:

```sh
# modules/zsh.nix の programs.zsh.shellAliases を編集
home-manager switch --flake ~/dev/dotfiles#komusan
exec zsh   # 新しい zsh を起動して反映
```

### B. プロジェクトのランタイムを管理したいとき（③に手を加える）

Rails プロジェクトに ruby 3.2.4 を入れる例:

```sh
cd ~/dev/your-rails-app

# 1. flake.nix を作成（docs/flake-template.md を参考）
$EDITOR flake.nix

# 2. .envrc を作成
echo "use flake" > .envrc

# 3. direnv に許可を出す
direnv allow
#   ↑ 初回のみ。以後は cd するだけで自動で ruby/bundler が PATH に入る

# 4. 動作確認
ruby --version    # → 3.2.4
bundle --version
```

別プロジェクトに `cd` した瞬間、direnv が前プロジェクトの環境を unload して新しいプロジェクトの flake を評価する。**シェル再起動も `rbenv shell` も不要**。

### C. GUI / Cask アプリを足したいとき（①に手を加える）

```sh
# 1. Brewfile に追記
$EDITOR ~/dev/dotfiles/Brewfile
#   cask "raycast"  などを足す

# 2. 適用
brew bundle install --file=~/dev/dotfiles/Brewfile
```

（Phase 5 で `homebrew.casks = [ "raycast" ];` に統合予定）

## 3. メンテナンス: flake.lock の更新

`flake.lock` は inputs（nixpkgs / home-manager 等）のコミットを固定する。固定したまま放置するとセキュリティ修正やバグ修正を取り逃すので、定期的に更新する。

```sh
# 全 inputs を更新
nix flake update
home-manager switch --flake .#komusan

# 特定の input だけ更新
nix flake update nixpkgs
```

**頻度の目安**: 1〜2 ヶ月に 1 回。古すぎると cache miss でローカルビルドに落ちるので、定期更新は実利的にも重要。

更新後に問題が出たら `git checkout flake.lock` で戻せばロールバック可能。

## 4. 環境を壊した / 戻したいとき

home-manager は世代（generation）を持っているので、いつでも前の状態に戻せる。

```sh
# 世代一覧を見る
home-manager generations

# 1 つ前の世代に戻す（パスは generations の出力から）
/nix/store/...-home-manager-generation/activate

# 古い世代を削除（ディスク節約）
home-manager expire-generations '-30 days'
nix-collect-garbage --delete-older-than 30d
```

## 5. 新しい Mac にセットアップする

```sh
# 0. Homebrew + Brewfile（GUI/Cask アプリ）
brew bundle install --file=Brewfile

# 1. Determinate Nix
curl -L https://install.determinate.systems/nix | sh -s -- install

# 2. dotfiles を clone
git clone <repo-url> ~/dev/dotfiles && cd ~/dev/dotfiles

# 3. home-manager を 1 発で発火
nix run home-manager/master -- switch --flake .#komusan -b backup
```

これで CLI ツール・シェル・エディタ・direnv が揃う。各プロジェクトは clone して `direnv allow` するだけで動く。

## 6. 困ったときの切り分けフロー

| 症状 | 原因の当たり |
|---|---|
| `home-manager switch` が遅い・止まる | flake.lock が古く cache miss → `nix flake update` |
| `cd` してもランタイムが切り替わらない | `direnv allow` 忘れ / `.envrc` 未配置 / `direnv reload` |
| 「foreign file exists」で switch 失敗 | 旧 symlink が残存 → `-b backup` で退避するか手動削除 |
| zsh エイリアスが反映されない | 既存シェルがキャッシュ → `exec zsh` |
| パッケージのソースビルドが始まる | nixpkgs リビジョンが cache に無い → `nix flake update nixpkgs` |
| `compinit` で zsh が遅い | 既知問題（別 Issue） → 一時しのぎは `compinit -C` |

## 7. アンチパターン（やらないこと）

- ❌ `home.packages` に `ruby` / `nodejs_20` 等の言語ランタイムを入れる
  → プロジェクトごとに per-project flake で管理する
- ❌ Brewfile に `jq` / `gh` 等の CLI ツールを入れる
  → `home.packages` に書く
- ❌ `~/.zshrc` を直接編集する
  → `modules/zsh.nix` を編集して `home-manager switch`
- ❌ `nix-env -i <pkg>` で個別インストール
  → 命令的でリポに残らない。`home.packages` に書く
- ❌ flake.lock を git ignore する
  → 再現性が壊れる。必ずコミットする

## 8. Phase 5（将来）で何が変わるか

nix-darwin 導入で:

- **Brewfile が `homebrew.casks` に吸収**（① と ② の境界が消える）
- macOS システム設定（Dock / キーリピート等）も flake で宣言
- セットアップが `darwin-rebuild switch` 一発に統一

その時は `home-manager switch` の代わりに `darwin-rebuild switch --flake .#<host>` を使うようになるが、運用感覚は今と同じ。

## 関連ドキュメント

- [flake-template.md](./flake-template.md): per-project `flake.nix` のテンプレート集
- [../README.md](../README.md): リポジトリの構造と初回セットアップ手順
- [../CLAUDE.md](../CLAUDE.md): Claude Code 向けガイドライン
