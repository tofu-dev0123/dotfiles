---
name: create-pr
description: PRを自動作成する（タイトル・本文をコミットから自動生成）。ユーザーがPR、プルリクエストの作成について言及したときは必ずこのスキルを使う
argument-hint: [base-branch]
tools: [Bash]
---

以下の手順でGitHub PRを作成してください。

## 手順

1. ベースブランチを確認する（引数 `$ARGUMENTS` が指定されていれば使用、なければ `main`）

2. 以下のコマンドで情報を収集する：
   - `git branch --show-current` で現在のブランチを確認
   - `git log <base-branch>...HEAD --oneline` でコミット一覧を取得
   - `git diff <base-branch>...HEAD --stat` でdiffサマリーを取得
   - `git diff <base-branch>...HEAD` でdiff全文を取得

3. 収集した情報を元に以下を生成する：
   - **PRタイトル**: 変更内容を簡潔に表す日本語タイトル（70文字以内）
   - **PR本文**: git diffとコミットメッセージを分析し、以下のフォーマットで作成
     ```
     ## 概要
     <!-- このPRで何をしたかを1〜3行で簡潔に説明 -->
     - 変更内容の箇条書き（1〜3項目）

     ## 背景・モチベーション
     <!-- なぜこの変更が必要か、解決する問題や目的を記述 -->

     ## 変更の詳細
     <!-- 変更したファイル・箇所・ロジックの説明 -->
     - 主な変更点の箇条書き

     ## 動作確認
     <!-- 動作確認の手順や確認した内容 -->
     - [ ] 確認項目

     ## 注意事項・補足
     <!-- レビュアーへの補足、既知の問題、今後の課題など（任意） -->

     🤖 Generated with [Claude Code](https://claude.com/claude-code)
     ```

4. `git push -u origin <current-branch>` でブランチをリモートにプッシュする

5. `gh pr create --base <base-branch> --title "<タイトル>" --body "<本文>"` でPRを作成する

6. 作成されたPRのURLを表示する
