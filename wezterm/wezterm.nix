{ config, ... }:
# Nix 化していない wezterm 設定を mkOutOfStoreSymlink で配置する
let
  source = "${config.home.homeDirectory}/dev/dotfiles/wezterm/.config/wezterm";
in
{
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink source;
}
