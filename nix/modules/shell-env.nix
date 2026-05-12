{ config, ... }:
# シェル全般の環境変数
# 旧 zsh/.zshenv の export 群を集約
# XDG 4 変数と ZDOTDIR は xdg.enable / programs.zsh が自動設定するため記述不要
#
# 注意: home.sessionVariables は home-manager が hm-session-vars.sh 経由で読み込ませるため
# 対話シェルでのみ有効。非対話シェルでの伝搬問題は #59 で別途対応する想定。
{
  home.sessionVariables = {
    # nh のデフォルト flake パス（nh home switch だけで切り替え可能に）
    NH_FLAKE = "${config.home.homeDirectory}/dev/dotfiles";

    # less の履歴を保存しない
    LESSHISTFILE = "-";

    # REPL/CLI 履歴を XDG_STATE_HOME 配下に予防的に振る
    MYSQL_HISTFILE = "${config.xdg.stateHome}/mysql/history";
    SQLITE_HISTORY = "${config.xdg.stateHome}/sqlite/history";
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/repl_history";

    # 言語ランタイム/CLI のキャッシュ・設定を XDG 配下へ
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    # DOCKER_CONFIG は docker パッケージ群と併せて docker/docker.nix で管理
  };
}
