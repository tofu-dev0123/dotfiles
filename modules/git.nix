{ ... }:
# git 設定
# 旧 git/.config/git/config と git/.config/git/ignore を programs.git で宣言的に管理
{
  programs.git = {
    enable = true;

    settings.user = {
      name = "tofu-dev0123";
      email = "m.komukai0123@gmail.com";
    };

    ignores = [
      "**/.claude/settings.local.json"
    ];
  };
}
