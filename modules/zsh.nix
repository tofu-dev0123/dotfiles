{ config, ... }:
# zsh 設定
# 旧 zsh/.config/zsh/.zshrc, .zprofile, .zshenv を programs.zsh で宣言的に管理
# 半構造化部分 (alias / history / PATH) は attrset、シェル関数は別ファイルに切り出して readFile で取り込む
{
  programs.zsh = {
    enable = true;

    # fish 風のインライン補完候補（ghost text）。→ で確定
    autosuggestion.enable = true;

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

    # cd 関数等、Nix 式に分解しづらいシェル処理
    initContent = builtins.readFile ../zsh/zshrc-extra.sh;

    # 全 zsh 起動（非対話含む）で Nix の PATH を有効化する
    # Why: nix-installer 設置の /etc/zshrc は対話シェルのみ、/etc/zshenv は SSH 限定で
    # nix-daemon.sh を読み込む。そのため cron / launchd / Claude Code のフック等
    # 非対話シェルから home.packages のツール（gh / jq 等）が解決できない (#59)。
    envExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';

    # ログインシェルでのみ実行する Homebrew 環境設定
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  # PATH への追加
  # ユーザーローカル bin, npm-global bin
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];
}
