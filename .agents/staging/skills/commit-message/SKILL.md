---
name: commit-message
description: |
  git の commit message を `[area] summary` 形式で書く。
  commit message を書くとき、提案するとき、review するときに使う。
  「commit して」「commit message を書いて」「この message でいいか見て」で起動する。
  sync skill のように commit を作る他の skill からも、message の規約として参照される。
  /commit-message = staged な変更、または指定された変更に対する message を提案する。
---

# commit-message

commit message を書くときの共通の規約である。

## command

`/commit-message` の形式で起動する。subcommand は無い。

- 引数なし
  - 下記「手順」で message を提案する
  - 対象の指定があれば、その変更を対象にする
  - 指定が無ければ staged な変更を対象にする
  - staged な変更も無ければ、対象の変更を確認してから進める

## repo 固有の値

操作対象の repo の root に `.agents/bindings/commit-message.md` があれば最初に読む。root は `git rev-parse --show-toplevel` で求める。

binding は次を定める。

- その repo で使う prefix の一覧と、それぞれが指す範囲
- prefix を付けない例外

binding が無い repo では次の既定で動く。

- repo の AGENTS.md / CLAUDE.md に commit の規約があれば、それに従う
- prefix は既存の履歴から選ぶ
- 履歴に `[area]` 形式が無い repo では、変更の主対象の directory 名か component 名から prefix を作る
- 例外は無いものとして扱う

## 規約

- subject は `[area] summary` の形にする
  - 例は `[entries] fix typos in digital-legacy` である
  - `area: summary` の形は使わない
- `[area]` は変更の主対象を表す、小文字の名詞にする
- prefix は 1 つだけ付ける
  - 複数の領域にまたがる場合は、最も中心的な領域を選ぶ
- prefix の後ろに半角スペースを 1 つ置く
- summary は英語で書く
- summary は命令形の現在形で短く書く
- 本文を書く場合も英語で書く
- 括弧は半角の `[]` を使う
- summary は変更内容から書く。定型の文言を機械的に流用しない

## 手順

1. message を付ける変更の範囲を確認する
   - staged な変更があれば `git diff --staged --stat` を使う
   - 無ければ `git diff --stat` を使う
   - どの directory や component への変更かを見極める
2. prefix を選ぶ
   - binding に一覧があれば、そこから選ぶ
   - 無ければ既存の prefix を調べ、それに合わせる
   - 既存の prefix を再利用する。新しい prefix をむやみに増やさない
   - 一覧にも履歴にも合うものが無い場合に限り、対象を表す新しい prefix を作る
   - 表記ゆれを作らない。単数と複数、綴りの違いは既存の側に寄せる
3. `[area] summary` の形で message を書く

既存の prefix は次の command で調べる。

```sh
git log --format='%s' | grep -oE '^\[[^]]+\]' | sort | uniq -c | sort -rn
```

## してはいけないこと

- 既存の commit の message を遡って書き換える
- 意味のない prefix を新設する
- 1 つの commit に複数の prefix を付ける
- 全角の括弧を使う
