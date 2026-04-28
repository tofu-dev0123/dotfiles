{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/dev/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  xdg.configFile = {
    "nvim".source         = link "nvim/.config/nvim";
    "wezterm".source      = link "wezterm/.config/wezterm";
    "zsh".source          = link "zsh/.config/zsh";
    "git".source          = link "git/.config/git";
    "starship.toml".source = link "starship/.config/starship.toml";
  };

  home.file = {
    ".zshenv".source                       = link "zsh/.zshenv";
    ".claude/settings.json".source         = link "claude/.claude/settings.json";
    ".claude/CLAUDE.md".source             = link "claude/.claude/CLAUDE.md";
    ".claude/skills".source                = link "claude/.claude/skills";
    ".claude/statusline-command.sh".source = link "claude/.claude/statusline-command.sh";
  };
}
