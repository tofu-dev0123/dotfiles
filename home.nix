{ config, pkgs, ... }:
{
  imports = [
    ./nix/modules/shell-env.nix
    ./docker/docker.nix
    ./nvim/nvim.nix
    ./wezterm/wezterm.nix
    ./claude/claude.nix
    ./zsh/zsh.nix
    ./git/git.nix
    ./starship/starship.nix
    ./direnv/direnv.nix
    ./lazygit/lazygit.nix
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
    imagemagick
    jq
    lua54Packages.luacheck
    nh
    nixfmt
    railway
    serie
    shellcheck
    statix
    stylua
  ];

  # fzf を有効化（programs.zsh と組み合わせて .zshrc に統合コードを自動挿入）
  programs.fzf.enable = true;

  programs.home-manager.enable = true;
  xdg.enable = true;
}
