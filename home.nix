{ config, pkgs, ... }:
{
  imports = [
    ./modules/dotfiles.nix
    ./modules/shell-env.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/direnv.nix
  ];

  # home.username / home.homeDirectory は flake.nix の mkHome から注入される
  home.stateVersion = "25.05";

  # programs.* で管理されないツールのみ home.packages で宣言
  # (fzf / git / starship は対応する programs.* モジュールで自動インストールされる)
  home.packages = with pkgs; [
    cosign
    cowsay
    eza
    gh
    jq
    lazygit
    lua54Packages.luacheck
    nh
    railway
    shellcheck
    stylua
  ];

  # fzf を有効化（programs.zsh と組み合わせて .zshrc に統合コードを自動挿入）
  programs.fzf.enable = true;

  programs.home-manager.enable = true;
  xdg.enable = true;
}
