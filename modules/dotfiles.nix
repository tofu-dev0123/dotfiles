{ config, ... }:
# Nix 非対応 / Nix 化していないツールの dotfiles を mkOutOfStoreSymlink で配置する。
# zsh / git / starship は programs.* に移行済みのためここでは扱わない。
let
  dotfilesPath = "${config.home.homeDirectory}/dev/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  xdg.configFile = {
    "nvim".source    = link "nvim/.config/nvim";
    "wezterm".source = link "wezterm/.config/wezterm";
  };

  home.file = {
    ".claude/settings.json".source         = link "claude/.claude/settings.json";
    ".claude/CLAUDE.md".source             = link "claude/.claude/CLAUDE.md";
    ".claude/skills".source                = link "claude/.claude/skills";
    ".claude/statusline-command.sh".source = link "claude/.claude/statusline-command.sh";
  };
}
