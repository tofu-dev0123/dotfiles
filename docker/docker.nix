{ config, pkgs, ... }:
# Docker CLI 関連の設定
#
# macOS 上での Docker ランタイムは Docker Desktop ではなく Colima を使う。
# docker / docker-compose / docker-buildx / colima を nixpkgs から導入し、
# DOCKER_CONFIG を XDG 配下（~/.config/docker）に固定する。
#
# `docker compose` / `docker buildx` は CLI プラグイン方式で動くため、
# nixpkgs の libexec パスを ~/.config/docker/cli-plugins/ にリンクする。
#
# 運用注意:
# - Homebrew で docker / docker-compose / docker-buildx / colima を入れないこと
#   （Brewfile にも追加しない）。Homebrew 版の docker は config パスや CLI プラグイン
#   検索パスの扱いが nix と噛み合わず、`docker compose` のサブコマンドが見えなくなる。
# - 変更後は `home-manager switch --flake .#<user>` の再適用を忘れずに。
{
  home.sessionVariables = {
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
  };

  home.packages = with pkgs; [
    docker-client
    docker-compose
    docker-buildx
    colima
    lazydocker
  ];

  xdg.configFile = {
    "docker/cli-plugins/docker-compose".source =
      "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
    "docker/cli-plugins/docker-buildx".source =
      "${pkgs.docker-buildx}/libexec/docker/cli-plugins/docker-buildx";
  };
}
