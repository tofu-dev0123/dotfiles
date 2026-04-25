# shellcheck shell=bash
# XDG Base Directory Specification
# .zshenv は全ての zsh 起動で最初に読み込まれる唯一のファイル
# XDG 変数と ZDOTDIR をここで定義することで、後続の .zshrc やサブシェル全体に伝搬する

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# zsh 本体の設定ファイル探索先を XDG 配下に寄せる
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# less の履歴を保存しない（XDG 化のため $HOME 直下の .lesshst を発生させない）
export LESSHISTFILE="-"

# REPL/CLI 履歴を XDG_STATE_HOME 配下に予防的に振る
# （ホストでこれらのツールを使う場面が出てきても $HOME 直下に履歴が生成されないようにする）
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql/history"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite/history"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/repl_history"

# 言語ランタイム/CLI のキャッシュ・設定を XDG 配下に
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
