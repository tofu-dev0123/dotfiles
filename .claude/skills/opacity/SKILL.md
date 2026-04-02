---
name: opacity
description: WeztermのWindow背景透過率を設定する（0〜1）。ユーザーがWeztermの透明度、透過率、opacity設定について言及したときは必ずこのスキルを使う
argument-hint: <opacity 0.0~1.0>
tools: [Read, Edit]
---

引数 `$ARGUMENTS` を WeztermのWindow背景透過率として設定する。

## 手順

1. 引数の検証
   - `$ARGUMENTS` が指定されていない場合はエラーメッセージを表示して終了する
   - `$ARGUMENTS` が 0〜1 の範囲の数値でない場合はエラーメッセージを表示して終了する

2. 設定ファイルを編集する
   - `wezterm/appearance.lua` を読み込む
   - `window_background_opacity = <現在の値>` の行を `window_background_opacity = $ARGUMENTS` に書き換える

3. 変更内容を報告する
   - 変更前後の値を表示する
   - 変更したファイルのパスを表示する
   - WeztermをリロードするコマンドはWezterm起動中に `Ctrl+Shift+R` で反映できることを案内する
