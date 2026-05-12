{ config, ... }:
# Nix 化していない AeroSpace 設定を mkOutOfStoreSymlink で配置する
let
  source = "${config.home.homeDirectory}/dev/dotfiles/aerospace/.config/aerospace";
in
{
  xdg.configFile."aerospace".source = config.lib.file.mkOutOfStoreSymlink source;
}
