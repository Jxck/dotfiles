---
name: planning
description: Create and iterate on implementation plans under .agents/plan/ with an automated Claude-Codex review loop. Use when entering plan mode, drafting an implementation plan, or reviewing an existing plan.
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

## 自動レビューループ (既定の進め方)

プラン作成を依頼されたら、ユーザーの介在なしに以下を最後まで回す
(2026-08-04 導入。それ以前の「Codex は人力起動」運用は廃止):

1. **初稿**: Claude (Fable) が WIP Plan を書く (上記 2 の形式)
2. **Codex review (round 1)**: Claude が `codex exec` で Codex を起動し、
   `## Review by Codex (日付)` をファイル末尾に追記させる (起動形は後述)
3. **Answer**: Claude が `## Answer by Claude (日付)` で全 finding に回答する
   (受け入れ / 反論は根拠付きで。事実主張は必ず検証してから応答する)
4. **Codex review (round 2)**: 再度 `codex exec` で「Answer を読んで残る懸念の追記、
   無ければ approve の明記」を依頼する
5. **Fix**: blocker が解消していれば Claude が本文を清書して `# Fixed Plan:` 化する
   (Review / Answer セクションは verbatim で保全)。blocker が残る場合は 3-4 を
   もう 1 巡し、それでも割れる論点は TBD に残して WIP のままユーザーへ
6. **終了報告**: plan の概要 (tldr 相当) と、**人間が判断すべき残り TBD** を明示して終わる。
   TBD ゼロならその旨を言い、実装開始の指示を待つ (「実装して」と言われていた場合は続行)

## Codex の起動形

```sh
codex exec --sandbox workspace-write "<自己完結の依頼文>"
```

- 認証は `~/.codex/auth.json`、モデル・設定はリポジトリの `.codex/config.toml` が正。
  実行はユーザーの Codex 側課金を消費する (プランレビュー時のみの利用に留める)
- 依頼文に含めるもの: 対象 plan の相対パス / 追記するセクション名
  (`## Review by Codex (日付)`) / 「既存セクションを書き換えない」/ レビュー観点 /
  TBD への推奨判断を求める旨。round 2 では「Answer by Claude を読み、残る懸念が
  なければ approve を明記」と書く
- **書き込みが落ちることがある**: workspace-write でも Codex がファイル追記を
  行わない場合がある (レビュー本文は生成済みでセッションに残っている)。その場合は
  `codex exec --sandbox danger-full-access resume --last "<plan パス> の末尾にいま作成した
  レビュー全文を追記して"` で同一セッションを再開して書かせる (2026-08-04 実測で有効)
- 出力を pipe で切り詰めない (`| tail` はレビュー全文をログから失う。実測の教訓)。
  background 実行にして完了通知で回収し、追記の成否はファイル側の diff で確認する
- CLI が古くて model エラーになったら `brew upgrade codex` を試し、
  それでも不可なら人力起動へフォールバックしてユーザーに報告する
- **Codex が usage limit で使えないときは `deep-reasoner` (Opus、独立コンテキスト) を
  代役レビュアーに立ててループを継続できる** (2026-08-05 実績: blocker 0 / major 6 /
  minor 8 を検出し、復帰後の Codex round とも矛盾しなかった)。依頼文は Codex と同様に
  自己完結で書き、セクション名は `## Review by Claude Opus (deep-reasoner) (日付)` にする。
  代役を使ったことと round 数は plan に明記する

## Workflow Rules

- プランは cross-tool で共有するため、Claude / Codex / 他 Agent のいずれでも読み書きできる Markdown に保つ
- Agent 名は自分のツール名 (`Claude`, `Codex`, ...) を明記する
- 日付は今日の日付 (JST) を使い、ファイル名は絶対にあとから変えない
- 初稿は必ず `# WIP Plan:` で始める
- `# Fixed Plan:` にするのは、レビューを反映して方針が固まった後だけにする
- Codex はレビュアーではなく対等なピアとして扱う。finding への反論は許されるが、
  事実主張 (「X は検査対象ではない」等) は必ずコードで裏取りしてから答える
- **レビュー観点の正**: repo に `review` skill (`.agents/skills/review/`) がある場合、
  レビュー依頼文と Answer の双方でその観点カタログ (owner の不在 / gate の追従 /
  acceptance の空振り / platform 挙動の probe 等) を適用する

## command

サブコマンドとして以下を受け取ったら、対応した処理を行う。

- `create`: プランニングを開始するが、次の入力で「何をプランしたいのか」を言われるまで待機する。
  対象が決まったら自動レビューループを最後まで回す
- `review`: 現在のプランをレビューしレビュー結果を追記する (自分がレビュアー側の場合)。
  Codex のレビューが欲しい文脈なら `codex exec` で起動する
- `answer`: 追加されたレビューに返信を追記する
- `update`: ここまでのレビューをすべて踏まえてプランを更新する。方針が固まっていれば `# Fixed Plan:` として清書し、未確定なら `# WIP Plan:` のまま更新する
- `todo`: プランの中で、意思決定が必要な項目の残りをリストで表示する
- 手動サブコマンドはループの途中から使ってよい (例: 人が書いた Review への `answer`)
