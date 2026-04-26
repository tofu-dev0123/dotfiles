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

### Claude Code 設定（`claude/.claude/`）
- グローバルスキルは `claude/.claude/skills/<name>/SKILL.md` で管理（`~/.claude/skills` へシンボリックリンク）
- プロジェクトスキルは `.claude/skills/<name>/SKILL.md` で管理
- スキルのフォーマット: YAML フロントマター（`description`, `argument-hint`, `allowed-tools`）+ 本文

## コマンド

- セットアップ: `./setup.sh`（`--dry-run` で事前確認、`--clean-backups` で旧バックアップ削除）
- PR 作成: `/pr [base-branch]`（`claude/.claude/skills/pr/SKILL.md` に定義済み）
- Issue 作成: `/issue [topic]`（`claude/.claude/skills/issue/SKILL.md` に定義済み）
