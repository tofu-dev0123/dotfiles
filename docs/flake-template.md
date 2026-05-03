# per-project flake テンプレート

各プロジェクトのランタイムは dotfiles 側ではなく、プロジェクト直下の `flake.nix` + `.envrc` で管理する。
`cd` した瞬間に direnv (`use flake`) が flake を評価し、必要なランタイムが PATH に乗る。

## 共通: `.envrc`

どのテンプレートでも `.envrc` は同じ。

```sh
use flake
```

初回のみ `direnv allow` が必要。

## Ruby（Rails 等で任意バージョンを使う）

`nixpkgs` には主要 Ruby のメジャーバージョンしかないので、exact patch（例: `3.2.4`）を引きたい場合は
[`nixpkgs-ruby`](https://github.com/bobvanderlinden/nixpkgs-ruby) を使う。

```nix
{
  description = "Rails project";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-ruby.url  = "github:bobvanderlinden/nixpkgs-ruby";
    flake-utils.url   = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-ruby, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ruby = nixpkgs-ruby.packages.${system}."3.2.4";
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            ruby
            pkgs.bundler
            pkgs.nodejs_20    # asset pipeline 用
            pkgs.libyaml      # psych ビルドに必要なことが多い
          ];

          shellHook = ''
            export GEM_HOME="$PWD/.gem"
            export PATH="$GEM_HOME/bin:$PATH"
          '';
        };
      });
}
```

## Node.js

```nix
{
  description = "Node project";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nodejs_20
            pkgs.pnpm
          ];
        };
      });
}
```

特定の Node マイナーバージョンが必要なら、`nixpkgs` のコミットを pin するか
[`nodejs-flake`](https://github.com/nix-community/nixpkgs-node) を使う。

## Python

```nix
{
  description = "Python project";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.python312
            pkgs.uv          # or poetry / pdm
          ];
        };
      });
}
```

## 複数言語を同時に使う

```nix
devShells.default = pkgs.mkShell {
  packages = [
    pkgs.nodejs_20
    pkgs.python312
    pkgs.go
    pkgs.terraform
  ];
};
```

## .gitignore に追加するもの

direnv / nix-direnv が生成するキャッシュ:

```
.direnv/
.envrc.cache
```

## トラブルシューティング

| 症状 | 対処 |
|---|---|
| `direnv: error .envrc is blocked` | `direnv allow` を実行 |
| flake 変更が反映されない | `direnv reload` で再評価 |
| キャッシュが壊れた | `rm -rf .direnv && direnv reload` |
| `nix-direnv` が読み込まれない | `programs.direnv.nix-direnv.enable = true` を確認 |
