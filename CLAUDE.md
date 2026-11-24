# CLAUDE.md

このファイルは Claude Code がこのリポジトリで作業する際のガイドラインです。

## プロジェクト概要

macOS 向けの開発環境設定ファイル（dotfiles）リポジトリ。シンボリックリンクで各設定を `~/.config` 等に配置する。
リポジトリ構成・管理対象ツール・セットアップ手順は README.md を参照。

各パッケージディレクトリ内は `$HOME` 配下の構造をそのまま反映する **HOME ミラー型**で構成されている
（例: `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`）。

## 作業上の注意

### 全般
- コメントや説明は日本語で記述する
- PR タイトルも日本語で記述する（`/pr` コマンドを使用）

### Neovim 設定（`nvim/.config/nvim/`）
- プラグイン設定はすべて `nvim/.config/nvim/lua/plugins/` 以下に個別ファイルで管理
- コアオプションは `nvim/.config/nvim/lua/core/options.lua`、キーマップは `nvim/.config/nvim/lua/core/keymaps.lua`
- プラグイン追加時は `nvim/.config/nvim/lua/plugins/` に新しい `.lua` ファイルを作成し、README.md のプラグイン一覧も更新する

### Claude Code 設定
- `~/.claude`（グローバルの設定・スキル）は dotfiles では扱わない。[conventions](https://github.com/tofu-dev0123/conventions) の `user` ターゲットの sync で配る
- プロジェクトスキルは `.claude/skills/<name>/SKILL.md` で管理
- スキルのフォーマット: YAML フロントマター（`description`, `argument-hint`, `allowed-tools`）+ 本文

### ランタイム管理の方針
- 言語ランタイム（ruby / node / python 等）は dotfiles では扱わず、各プロジェクトの `flake.nix` + direnv で管理する
- `home.packages` は CLI ツール（jq / gh / lazygit 等）のみを置く
- per-project flake のテンプレートは `docs/flake-template.md` を参照

## コマンド

- セットアップ（初回）: `nix run home-manager/master -- switch --flake .#komusan -b backup`
- 通常適用: `home-manager switch --flake .#komusan`
- PR 作成: `/pr [base-branch]`（conventions が配るグローバルスキル）
- Issue 作成: `/feature`（機能追加）・`/bugfix`（バグ）（conventions の issue-driven が配る）
- 実装: `/implement <issue-number>`（計画から PR まで）
- ローカル CI チェック: `./scripts/check`（`/check` スキルからも実行できる）
- 適用前の確認（実環境を変えない）: `home-manager build --flake .#komusan`

## 設計書

- 作業の設計書は GitHub Issue。Issue の「やること」「やらないこと」「完了条件」に沿って進める
- 構成の運用方針は `docs/nix-operation-guide.md`、per-project flake は `docs/flake-template.md`
- ツール・プラグインの一覧とセットアップ手順は README.md

## 禁止事項

- `home-manager switch`・`brew bundle` を確認なしに実行しない（実環境を書き換える。検証は `home-manager build` で行う）
- 言語ランタイムを `home.packages` に追加しない（上記「ランタイム管理の方針」）
- `~/.claude` 配下や conventions の生成物（`.claude/rules/shared/common.md` の表）を手で編集しない
