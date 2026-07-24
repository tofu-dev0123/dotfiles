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

# pj (project jump): ホームディレクトリ配下の git リポジトリのルートを fzf で選んで移動する。
# 引数で検索起点となる ~/ 配下のディレクトリを指定できる（例: `pj work` → ~/work、無指定は ~/dev）。
# fd で .git ディレクトリを列挙し、親（リポジトリルート）を抽出して候補にする。
# fd は隠しファイル・.gitignore を既定で除外するため候補がノイズなく絞られる。
pj() {
	local base="$HOME/${1:-dev}"
	local dir
	[ -d "$base" ] || { echo "pj: no such directory: $base" >&2; return 1; }
	dir=$(fd --type d --hidden '^\.git$' "$base" | sed 's|/\.git/*$||' | fzf) || return
	cd "$dir" || return
}
