---
name: planning
description: Create and iterate on implementation plans under .agents/plan/ so multiple agents (Claude / Codex / 他) can review each other's drafts. Use when entering plan mode, drafting an implementation plan, or reviewing an existing plan.
---

# planning

このリポジトリで実装プランを作成し、複数 Agent が相互レビューするときの共通ルールである。

プラン運用に関する正本ルールはこの skill に集約する。
`AGENTS.md` には `planning` skill を使うことだけを書き、詳細な workflow はここに置く。

## 起動時にやること

1. リポジトリの `AGENTS.md` または `CLAUDE.md` があれば読み、共通ルールを確認する
2. プランを作る場合
   - `.agents/plan/YYYYMMDD-HHMM-概要.md` を新規作成する
   - 初稿は `# WIP Plan: プラン名` で始め、本文を `## Plan by (Agent 名)` に書く
   - 最初のセクションを `## tldr` として、それ以降の概要を 5 行にまとめる
   - レビューアーの判断が必要な項目は、最後に `## TBD` セクションを作りそこにまとめる
3. 既存プランをレビューする場合
   - 対象ファイルを読み、末尾に `## Review by (Agent 名)` を追記する
   - 既存の `## Review by (...)` / `## Answer by (...)` を勝手に書き換えない
4. レビューに応答する場合
   - 末尾に `## Answer by (Agent 名)` を追記する
5. 方針が固まったら全体を清書し、同じファイルを `# Fixed Plan: プラン名` で上書きする

## Workflow Rules

- プランは cross-tool で共有するため、Claude / Codex / 他 Agent のいずれでも読み書きできる Markdown に保つ
- Agent 名は自分のツール名 (`Claude`, `Codex`, ...) を明記する
- 日付は今日の日付 (JST) を使い、ファイル名は絶対にあとから変えない
- 初稿は必ず `# WIP Plan:` で始める
- `# Fixed Plan:` にするのは、レビューを反映して方針が固まった後だけにする

## command

サブコマンドとして以下を受け取ったら、対応した処理を行う。

- `create`: プランニングを開始するが、次の入力で「何をプランしたいのか」を言われるまで待機する
- `review`: 現在のプランをレビューしレビュー結果を追記する
- `answer`: 追加されたレビューに返信を追記する
- `update`: ここまでのレビューをすべて踏まえてプランを更新する。方針が固まっていれば `# Fixed Plan:` として清書し、未確定なら `# WIP Plan:` のまま更新する
- `todo`: プランの中で、意思決定が必要な項目の残りをリストで表示する
