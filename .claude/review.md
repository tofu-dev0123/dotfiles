# dotfiles 固有のレビュー観点

`reviewer` エージェントが汎用の観点（Issue との整合・conventions のルール）に加えて判定する。

## 必須

- R1. マシン固有の値をハードコードしていない。ユーザー名・`/Users/<name>` などの絶対パスは書かず、`config.home.homeDirectory`・`~`・`$HOME` を使う（`home.nix` はマシン非依存。ユーザー名は `flake.nix` の `mkHome` で注入する）
- R2. 会社用の git identity（`user.name`・`user.email`）や SSH 鍵の設定を含めていない。これらは `includeIf` の読み込み先（リポジトリ外の `~/.config/git/config.*`）に置く
- R3. 言語ランタイム（ruby・node・python 等）を `home.packages` に追加していない（CLAUDE.md「ランタイム管理の方針」）
- R4. 新しい設定ファイルは HOME ミラー型で置いている（`<パッケージ>/<$HOME からの相対パス>`）。配置に必要なリンク定義（各パッケージの `*.nix`）も同じ差分で追加・更新している

## 推奨

- R5. 一覧を README と揃えている
  - Neovim プラグインの追加・削除 → 「Neovim プラグイン一覧」
  - `home.packages`・`programs.*`・Brewfile での管理方式の変更 → 「セットアップ方式」の表
  - プロジェクトスキルの追加・削除 → 「Claude Code カスタムスキル」
- R6. 置き場所の分担を守っている。CLI ツールは `home.packages`、GUI・Cask アプリは Brewfile。同じツールを両方で管理していない
