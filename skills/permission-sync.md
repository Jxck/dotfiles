---
name: permission-sync
description: Sync and harden command permissions between .claude/settings.json and .codex/rules/default.rules in this dotfiles repo.
---

# permission-sync

このドキュメントは、`./.claude/settings.json` と `./.codex/rules/default.rules` を
安全性を維持しつつ双方向同期するための正本手順です。

## 使う場面

- 許可ルールを移行可能な形で整理したい
- `settings.json` と `default.rules` の差分をなくしたい
- 危険な権限を除外して read-only 寄りにしたい
- 見やすい順にソートしたい

## 手順

1. 現在値を確認する

```bash
sed -n '1,260p' ./.claude/settings.json
sed -n '1,260p' ./.codex/rules/default.rules
```

2. 安全ゲートを先に適用する（必須）

- 双方向同期の前に、両ファイルを同じ安全 allowlist でフィルタする
- 許可外は必ず削除する（片側にあっても復活させない）
- 例: `python3 *`, `npm *`, `pnpm *`, `cargo *`, `git checkout:*`, `git commit:*`, `git stash:*`, `brew bundle:*` は除外対象

3. 正規化して比較可能な形にする

- `settings.json` は `Bash(...)` 形式、`default.rules` は `prefix_rule(...)` 形式なので、同じ意味に正規化して比較する
- 表記ゆれは吸収する
  - 例: `Bash(ps:*)` <-> `prefix_rule(pattern=["ps"], decision="allow")`
  - 例: `Bash(git diff:*)` <-> `prefix_rule(pattern=["git", "diff"], decision="allow")`
- 並び順も統一する（セクション順 + セクション内ソート）

4. 双方向同期する

- お互いに無いものを追加し合う
- ただし追加対象は「安全ゲート通過済み」のものだけ
- 追加後、両ファイルが同じ許可集合になることを確認する

5. 同期後検証を行う（必須）

```bash
jq empty ./.claude/settings.json
sed -n '1,260p' ./.codex/rules/default.rules
```

- 両者の件数と要素が一致することを確認する
- 許可外コマンドが 1 つでも残っていれば失敗として修正する

## 安全ルール

- `auth.json` や `sessions` など機密/履歴は管理対象にしない
- マシン依存パスを含む許可は除外する
- 同期の原則は「安全フィルタ -> 正規化 -> 双方向同期 -> 同期後検証」
- この順序を崩さない

## ソート方針

- セクション順: `basic` -> `git` -> `gh` -> `brew`
- セクション内は「文字数が短い順、同じならアルファベット順」
- `settings.json` のセクションコメント（`// basic`, `// git`, `// gh`, `// brew`）は維持する
