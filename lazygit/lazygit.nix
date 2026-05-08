{ ... }:
# lazygit 設定
# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
{
  programs.lazygit = {
    enable = true;

    settings = {
      # 1. Catppuccin Frappe テーマ（starship と配色を統一）
      #    https://github.com/catppuccin/lazygit
      gui = {
        theme = {
          activeBorderColor = [ "#8caaee" "bold" ];   # blue
          inactiveBorderColor = [ "#a5adce" ];        # subtext0
          optionsTextColor = [ "#8caaee" ];           # blue
          selectedLineBgColor = [ "#414559" ];        # surface0
          cherryPickedCommitBgColor = [ "#51576d" ];  # surface1
          cherryPickedCommitFgColor = [ "#babbf1" ];  # lavender
          unstagedChangesColor = [ "#e78284" ];       # red
          defaultFgColor = [ "#c6d0f5" ];             # text
          searchingActiveBorderColor = [ "#e5c890" ]; # yellow
        };
        authorColors = {
          "*" = "#ca9ee6"; # mauve
        };
      };

      # 2. エディタを nvim に固定（`e` キー・コミットメッセージ編集で nvim が開く）
      os = {
        editPreset = "nvim";
      };

      # 3. Nix 管理なので lazygit 自身の自動アップデートは無効化
      update = {
        method = "never";
      };
    };
  };
}
