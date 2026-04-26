# shellcheck shell=bash
# .zprofile はログインシェルで .zshrc より前に読まれる
# ZDOTDIR が設定されているため $ZDOTDIR/.zprofile から読まれる

eval "$(/opt/homebrew/bin/brew shellenv)"
