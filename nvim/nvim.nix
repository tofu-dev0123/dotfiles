{ config, ... }:
# Nix 化していない nvim 設定を mkOutOfStoreSymlink で配置する
let
  source = "${config.home.homeDirectory}/dev/dotfiles/nvim/.config/nvim";
in {
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink source;
}
