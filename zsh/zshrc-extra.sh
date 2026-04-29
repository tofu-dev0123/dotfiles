# shellcheck shell=bash
# programs.zsh.initContent から builtins.readFile で読み込まれる
# Nix 式に分解しづらいシェル関数や eval をここに置く
#
# 注意: home-manager は initContent → shellAliases の順で .zshrc に挿入する。
# zsh の alias は関数定義時に展開されるため、ここで `ls` を書いても alias が未定義で展開されない。
# そのため eza を直接呼び出している。

cd() {
	builtin cd "$@" && eza -l --icons --group-directories-first
}

eval "$(rbenv init -)"
