# shellcheck shell=bash
# 履歴は XDG_STATE_HOME 配下に分離（HISTFILE は対話シェル固有のため .zshrc に置く）
export HISTFILE="$XDG_STATE_HOME/zsh/history"

export PATH="$HOME/.rbenv/shims:$PATH"

export PATH="$HOME/.local/bin:$PATH"

alias ls="eza --icons --group-directories-first"
alias ll="eza -lah --icons --git"
alias tree="eza --tree --icons"
alias fcd='cd "$(find . -type f | fzf | xargs dirname)"'
alias dcd='cd "$(find ~ -type d | fzf)"'

cd() {
	builtin cd "$@" && ls -l
}

# fzf シェル統合（キーバインド・補完を有効化）
eval "$(fzf --zsh)"

export PATH="$HOME/.npm-global/bin:$PATH"
eval "$(rbenv init -)"
eval "$(starship init zsh)"
