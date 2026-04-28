{ config, pkgs, ... }:
{
  imports = [ ./modules/dotfiles.nix ];

  home.username = "komusan";
  home.homeDirectory = "/Users/komusan";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  xdg.enable = true;
}
