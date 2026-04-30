{ config, pkgs, ... }:
{
  imports = [
    ./modules/dotfiles.nix
    ./modules/shell-env.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/starship.nix
  ];

  home.username = "komusan";
  home.homeDirectory = "/Users/komusan";
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
    railway
    shellcheck
    stylua
  ];

  # fzf を有効化（programs.zsh と組み合わせて .zshrc に統合コードを自動挿入）
  programs.fzf.enable = true;

  programs.home-manager.enable = true;
  xdg.enable = true;
}
