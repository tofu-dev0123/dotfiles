{ config, ... }:
# zsh 設定
# 旧 zsh/.config/zsh/.zshrc, .zprofile, .zshenv を programs.zsh で宣言的に管理
# 半構造化部分 (alias / history / PATH) は attrset、シェル関数は別ファイルに切り出して readFile で取り込む
{
  programs.zsh = {
    enable = true;

    # ZDOTDIR を XDG 配下に明示固定（25.05 のデフォルト変更警告への対応）
    dotDir = "${config.xdg.configHome}/zsh";

    history.path = "${config.xdg.stateHome}/zsh/history";

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --git";
      tree = "eza --tree --icons";
      fcd = ''cd "$(find . -type f | fzf | xargs dirname)"'';
      dcd = ''cd "$(find ~ -type d | fzf)"'';
    };

    # cd 関数 / rbenv init 等、Nix 式に分解しづらいシェル処理
    initContent = builtins.readFile ../zsh/zshrc-extra.sh;

    # ログインシェルでのみ実行する Homebrew 環境設定
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  # PATH への追加
  # rbenv shims, ユーザーローカル bin, npm-global bin
  home.sessionPath = [
    "${config.home.homeDirectory}/.rbenv/shims"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];
}
