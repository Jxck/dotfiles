---
name: agent-maintainer
description: Audit alignment between AGENTS.md and repo-local shared skills under .agents/skills. Invoke explicitly only; do not auto-trigger on generic agent or skill maintenance requests.
---

# agent-maintainer

このリポジトリの agent 運用ルールと shared skill レイアウトの整合を点検し、必要な整理を行うための skill である。

対象は repo ローカルの以下に限定する。

- `AGENTS.md`
- `.agents/skills/`
- `.claude/skills/`
- `.codex/skills/`
- `.agents/plan/`

repo 外の `~/.codex/...`、MCP server 設定、editor 設定は対象外とする。

## 起動時にやること

1. repo の `AGENTS.md` または `CLAUDE.md` を読み、repo 共通ルールを確認する
2. `.agents/skills/`, `.claude/skills/`, `.codex/skills/` の構造を確認する
3. shared skill の正本と symlink のズレを検出する
4. `AGENTS.md` と各 skill の間で、重複・矛盾・古い運用記述を洗い出す
5. ルールの置き場所を判断する
   - repo 共通 rule: `AGENTS.md`
   - task-specific rule: 対応 skill
6. 必要なら skill 正本へ移管し、`AGENTS.md` には参照だけを残す
7. shared skill ディレクトリ構成と symlink を整える
8. 最後に、移管・削除・共通化した点を短くまとめる

## What This Skill Maintains

- `AGENTS.md` を lean に保つ
  - repo 共通ルールだけを残す
  - task-specific rule は対応 skill に移す
- shared skill の正本を `.agents/skills/<skill>/` に揃える
- `.claude/skills/<skill>` と `.codex/skills/<skill>` を正本ディレクトリ symlink に揃える
- repo ローカル skill と `AGENTS.md` の責務分離を保つ
- `.agents/plan/` の命名規則や参照導線が `planning` skill と整合していることを確認する

## What This Skill Does Not Maintain

- 個別 plan ファイルの作成・レビュー・Fixed 化
- repo 外の設定やホーム配下の共通 skill
- MCP server 設定の最適化
- editor / formatter / shell の一般設定

## Notes

- `Skill Directory Workflow` のような shared rule は `AGENTS.md` を正本とする
- この skill 自身に shared rule の本文を複製しない
- plan workflow の作成・レビュー手順は `planning` skill の責務であり、この skill はその**定義の整合**だけを見る
