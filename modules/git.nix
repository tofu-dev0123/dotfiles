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

    # 会社/個人アカウントの自動切替
    # ~/work/<会社名>/ 配下では会社用 config (user.name / user.email / core.sshCommand) を読み込む
    # include 先のファイルは個人情報を含むため非管理（ローカルに手動配置）
    # 詳細は README.md「複数 Git アカウントの切替」を参照
    includes = [
      { condition = "gitdir:~/work/";       path = "~/.config/git/config.work-common"; }
      { condition = "gitdir:~/work/mk-dt/"; path = "~/.config/git/config.mk-dt"; }
    ];

    ignores = [
      "**/.claude/settings.local.json"
    ];
  };
}
