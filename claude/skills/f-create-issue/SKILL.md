---
name: f-create-issue
description: ForgejoリポジトリにIssueを作成する。ユーザーがForgejo向けのIssue、課題、バグ報告の作成について言及したときは必ずこのスキルを使う
argument-hint: "[title]"
tools: [Bash]
---

以下の手順でForgejo Issueを作成してください。CLIは `tea` を使用します。

## 手順

1. 引数 `$ARGUMENTS` が指定されていればIssueタイトルとして使用する。指定がなければユーザーに作成したいIssueの内容を確認する

2. Issueの内容を整理する：
   - **タイトル**: 簡潔に問題・要望を表す日本語タイトル（70文字以内）
   - **本文**: `${CLAUDE_SKILL_DIR}/template.md` のフォーマットに従って作成する
     （コメント `<!-- ... -->` は削除し実際の内容に置き換える）

3. `tea issues create --title "<タイトル>" --description "<本文>"` でIssueを作成する

4. 作成されたIssueのURLを表示する
