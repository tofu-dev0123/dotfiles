# CLAUDE.md

このファイルは Claude Code がこのリポジトリで作業する際のガイドラインです。

## プロジェクト概要

macOS 向けの開発環境設定ファイル（dotfiles）リポジトリ。シンボリックリンクで各設定を `~/.config` 等に配置する。
リポジトリ構成・管理対象ツール・セットアップ手順は README.md を参照。

## 作業上の注意

### 全般
- コメントや説明は日本語で記述する
- PR タイトルも日本語で記述する（`/pr` コマンドを使用）

### Neovim 設定（`nvim/`）
- プラグイン設定はすべて `nvim/lua/plugins/` 以下に個別ファイルで管理
- コアオプションは `nvim/lua/core/options.lua`、キーマップは `nvim/lua/core/keymaps.lua`
- プラグイン追加時は `nvim/lua/plugins/` に新しい `.lua` ファイルを作成し、README.md のプラグイン一覧も更新する

### Claude Code 設定（`claude/`）
- グローバルスキルは `claude/skills/<name>/SKILL.md` で管理（`~/.claude/skills` へシンボリックリンク）
- プロジェクトスキルは `.claude/skills/<name>/SKILL.md` で管理
- スキルのフォーマット: YAML フロントマター（`description`, `argument-hint`, `allowed-tools`）+ 本文

## コマンド

- セットアップ: `./setup.sh`
- PR 作成: `/pr [base-branch]`（`claude/skills/pr/SKILL.md` に定義済み）
- Issue 作成: `/issue [topic]`（`claude/skills/issue/SKILL.md` に定義済み）
