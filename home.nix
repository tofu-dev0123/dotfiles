{ config, pkgs, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/dev/dotfiles";
in {
  home.username = "komusan";
  home.homeDirectory = "/Users/komusan";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  xdg.enable = true;

  # Phase 1 PoC: starship を mkOutOfStoreSymlink でリポジトリ実体に symlink
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship/.config/starship.toml";
}
