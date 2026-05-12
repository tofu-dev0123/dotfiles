{ config, pkgs, ... }:
# Docker CLI 関連の設定
#
# macOS 上での Docker ランタイムは Docker Desktop ではなく Colima を使う。
# docker / docker-compose / docker-buildx / colima を nixpkgs から導入し、
# DOCKER_CONFIG を XDG 配下（~/.config/docker）に固定する。
#
# `docker compose` / `docker buildx` は CLI プラグイン方式で動くため、
# nixpkgs の libexec パスを ~/.config/docker/cli-plugins/ にリンクする。
{
  home.sessionVariables = {
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
  };

  home.packages = with pkgs; [
    docker-client
    docker-compose
    docker-buildx
    colima
  ];

  xdg.configFile = {
    "docker/cli-plugins/docker-compose".source =
      "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
    "docker/cli-plugins/docker-buildx".source =
      "${pkgs.docker-buildx}/libexec/docker/cli-plugins/docker-buildx";
  };
}
