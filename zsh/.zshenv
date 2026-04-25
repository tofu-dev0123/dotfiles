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
