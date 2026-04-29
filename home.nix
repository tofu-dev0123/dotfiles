{ config, pkgs, ... }:
{
  imports = [ ./modules/dotfiles.nix ];

  home.username = "komusan";
  home.homeDirectory = "/Users/komusan";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    cosign
    cowsay
    eza
    jq
    lua54Packages.luacheck
    railway
    shellcheck
    stylua
  ];

  programs.home-manager.enable = true;
  xdg.enable = true;
}
