---
name: check
description: CIと同等のローカルチェックを実行する。shellcheck・luacheck・SKILL.md検証・nixfmt・statix・home-manager build を確認する。ユーザーが「チェック」「CI確認」「ローカルで確認」などと言ったときに使う
tools: [Bash]
---

リポジトリ直下で `./scripts/check` を1回の Bash ツール呼び出しで実行し、末尾のサマリ（PASS / SKIP / FAIL の一覧）をユーザーに伝える。

FAIL があれば、該当するチェックの出力から原因となるファイル・行を示す。
