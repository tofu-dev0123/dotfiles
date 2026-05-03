{ ... }:
# direnv + nix-direnv
# プロジェクトディレクトリの flake.nix / .envrc を cd 時に自動評価し、
# 言語ランタイムやプロジェクト依存をシェルに反映する。
# dotfiles 側ではグローバルランタイムを管理せず、各プロジェクトの flake.nix に委譲する。
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = false;
  };
}
