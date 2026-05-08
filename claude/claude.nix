{ config, ... }:
# Claude Code 関連ファイルを mkOutOfStoreSymlink で ~/.claude 配下に配置する
let
  base = "${config.home.homeDirectory}/dev/dotfiles/claude/.claude";
  link = path: config.lib.file.mkOutOfStoreSymlink "${base}/${path}";
in {
  home.file = {
    ".claude/settings.json".source         = link "settings.json";
    ".claude/CLAUDE.md".source             = link "CLAUDE.md";
    ".claude/skills".source                = link "skills";
    ".claude/statusline-command.sh".source = link "statusline-command.sh";
  };
}
