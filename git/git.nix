{ ... }:
# git 設定
# 旧 git/.config/git/config と git/.config/git/ignore を programs.git で宣言的に管理
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "tofu-dev0123";
        email = "m.komukai0123@gmail.com";
      };

      # 安全・事故防止系
      init.defaultBranch = "main";   # git init の初期ブランチを main に
      fetch.prune = true;            # fetch でリモート消滅ブランチの追跡参照を自動掃除
      push.default = "simple";       # push の挙動を明示（モダン Git のデフォルト）
      push.autoSetupRemote = true;   # 新規ブランチ初回 push で -u 不要
      rebase.autoStash = true;       # rebase 開始時に未コミット変更を自動 stash・終了時に復元

      # 表示系
      branch.sort = "-committerdate";       # git branch を最新更新順で表示
      tag.sort = "version:refname";         # git tag を semver 順で表示
      column.ui = "auto";                   # branch/tag を端末幅に応じてカラム表示
      diff.algorithm = "histogram";         # diff の質を上げる
      merge.conflictStyle = "zdiff3";       # コンフリクトマーカーに共通祖先も表示

      # alias
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status -sb";
        lg = "log --oneline --graph --decorate --all";
        last = "log -1 HEAD";
        unstage = "reset HEAD --";
        uncommit = "reset --soft HEAD~1";
      };
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
