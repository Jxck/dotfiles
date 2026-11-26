---
name: review-criteria
description: |
  plan review と code review に共通する規律と、実際に blocker を見つけてきた観点のカタログ。
  review の進め方は持たない。plan は planning skill、code は使っている tool の code review 機能が進め方を持ち、この skill はそこで当てる観点を与える。
  「レビュー観点を確認して」「観点を当てて」「見落としが無いか観点で見て」で起動する。
  planning skill の review loop では、レビュー依頼文と Answer の両方でこのカタログを適用する。
  /review-criteria = 対象が plan か code かを見て、対応する観点を当てる。
---

# review-criteria

plan review と code review の両方に共通する、規律と観点カタログの正本である。
各観点は、実際の review で blocker または bug を発見した実績から抽出した。
レビュアーが Claude か Codex か subagent かを問わず、同じ規律を適用する。

review の進め方は対象ごとに別の場所が持つ。

- plan
  - planning skill
- code
  - 使っている tool の code review 機能
  - Claude Code では `/code-review` である

## command

`/review-criteria` の形式で起動する。subcommand は無い。

- 引数なし
  - 対象が plan か code かを判断する
  - 「使い分け」に従って観点を当てる
  - 対象を判断できなければ確認してから進める

## repo 固有の値

操作対象の repo の root に `.agents/bindings/review-criteria.md` があれば最初に読む。root は `git rev-parse --show-toplevel` で求める。

binding は次を定める。

- その repo で蓄積した追加の観点と実例
- CI failure の調査や test の書き方を担当する、repo 側の skill や文書

binding が無い repo では、この skill の観点カタログだけを使う。

## レビュアーの規律

plan と code の両方に適用する。

- 事実主張は実測してから書く
  - 「X は検査対象ではない」「Y は既にある」などの主張を推測で断定しない
  - code / 設定 / 実行結果で裏付ける
  - `file:line` を根拠として付ける
  - 推測による指摘は、結果が正しくても review の信頼を損なう
- finding は blocker / major / minor に分類する
  - blocker が無ければ approve と明記する
  - 「概ね良い」で終えない
  - 次の行動が決まらない review は成立しない
- 反証を試みる
  - 成功 case の確認だけでは正しさは増えない
  - 設計が間違っていれば壊れる入力 / 境界 / 逆方向を 1 つ以上試す
- 失敗 case だけを見ない
  - 同型で通っている case と必ず横断比較する
  - ある browser engine だけで字幕の test が落ちた件では、同じ形の再生の test が全 engine で通っていた
  - この比較によって、原因を一時停止中の seek に絞れた
- 合意済みの finding を蒸し返さない
  - round 2 以降は Answer の質と反映の完全性を確認する
- 大きな finding には代替案を書く
  - 問題の指摘だけで終えない
  - 成立する構成まで示す
  - 例は `mv -T` に頼る案から、`symlink()` と `rename()` を組み合わせる案への変更である

## 回答者の規律

Answer を書く側に適用する。

- 全 finding に個別に回答する
  - 受け入れか反論かを明記する
  - どちらにも根拠を付ける
  - 反論する場合も、相手の事実主張を先に裏付ける
- 受け入れた内容は本文へ反映してから次の round へ進む
  - 次の round では、Answer の約束が本文に入ったかを最初に確認する
- 人間が判断する事項は TBD に分ける
  - 公開 behavior の変更と、価値観の trade-off がこれにあたる
  - 回答者が独断で決めない
  - 推奨案を添えて提示する
- 過去の判断を sunk cost で守らない
  - cwd 起点で path を解決する案は、round 2 の finding を受けて撤回した

## 観点カタログ

変更の種類を問わず、上から順に当てる。各観点に実例を添えてある。

### 1. owner の不在

生成物 / process / 設定には owner がいる。移動 / 削除 / 追加によって、次の担当が欠けていないかを確認する。

- 作る担当
- 起動する担当
- 変更後に反映する担当

実例は次のとおり。どちらも blocker だった。

- daemon を build していた compiler の設定を削除する案で、代替の build が定義されていなかった
- deploy script が 2 つある daemon の一方しか restart せず、他方の変更が本番に反映されなかった

### 2. gate の追従

機械検査は path を literal に持つ。rename / 移動 / 出力先の変更では、その path を名指しする gate を全て列挙する。
gate は対象を見失っても fail せず、検査だけが黙って抜ける場合がある。

- 見る場所
  - 検査 script が literal で持つ走査 root と除外 list
  - `.gitignore`
  - formatter の ignore 設定
  - 正規表現に埋め込まれた path
  - CI の upload path
- 除外 list は逆方向も見る
  - 生成物の directory が gate の入力に混ざっていないかを確認する

### 3. acceptance の空振り

「確認する」と書いた手順が、主張とは別の対象を確認していないかを検査する。

- CI の upload step は path が空でも success になる
  - `if-no-files-found: error` を付ける
- directory の 404 は、配下の個別 file が非公開であることを示さない
  - exact URL を検査する
- 「最初の PUT を待つ」検証は no-op の PUT を拾う場合がある
  - ETag が進んだ PUT を待つ
- artifact は upload の成功ではなく、目的の file の実在まで確認する
- 欠陥が発生する場所で検証が走っているかを確認する
  - dev server には CSP が無い
  - CI には build を通らない経路がある
  - 独立した更新経路は deploy 後の smoke を通らない

### 4. platform 挙動の思い込み

推測している platform の挙動は、5 分の probe で実測する。思い込みが外れた実例は次のとおり。

- `.gitignore` の末尾 slash 付きの pattern は symlink に効かない
- sh の `**` は、nested match があると flat match を落とす
- vite の `emptyOutDir: false` は `publicDir` を copy する
  - stale file は削除しない
- tsc は dot directory を include できる
- Service Worker と robots.txt は origin に束縛される
  - 他の host からは配信できない

### 5. 契約の混在と分離

1 つの command や経路に、実行環境の異なる責務が混ざっていないかを見る。

実例は build と公開確認の混在である。CI でも走る build の後段で本番を curl すると、network の無い環境の build が壊れる。責務を次のように分ける。

- build は network を使わない
- 公開後の smoke は本番環境専用の command にする
- deploy は smoke と同じ helper を再利用する

### 6. 順序と段階の取り違え

- 実施順を本文から復元できるかを見る
  - 後ろの作業を先に行うと、前の作業の記述が古くなる plan がある
- staged な設定で、編集対象が active な block か次段の block かを区別する
  - active な block を変えると「切替は no-op」という契約が壊れる
  - その場合、cutover 自体が behavior change になる
- rename と behavior change を同じ commit に混ぜない
  - bisect と review を可能にするためである

### 7. atomic publish の完全性

生成物の世代切替は次の順序に固定する。

1. temp に全て出力する
2. temp 上で検証する
3. 生成物 tree 全体の hash を求める
4. 完成後に rename する
5. atomic swap する
6. current の確定後に prune する

確認する点は次のとおり。

- hash の入力が source だけになっていないか
  - source だけだと、CSS / template / 年号の変更が no-op 扱いになる
- 失敗時に、最終名の不完全な directory を残していないか
  - 残すと、次回の build が完成品として再利用する
- 現行世代と同じ名前になる場合に、削除や再生成をしていないか
  - 現行を先に削除する経路を作らない

### 8. 名前の正直さ

directory 名と変数名は実態を正しく表す必要がある。名前と実態のずれ自体を finding にする。ずれた名前は後続の判断を誤らせる。

不正確な名前の実例は次のとおり。

- `tools/` に production の daemon を置く
- 特定の application の test directory に、repo 横断の test を置く

### 9. 収束する不変条件

autosave / retry / flush などの自動処理には 2 つの不変条件が必要である。

- 最終的に最新状態が必ず反映される
- error で無限に retry しない

autosave の実例は次のとおり。

- dirty でなければ送信しない
  - no-op の request を作らない
- 保存の成功後に未送信の revision が残っていれば、追加で送信する
  - 最新状態へ収束させる
- error や skip の場合は繰り返さない

### 10. テスト結果の読み方

- serial な describe では、failure の後ろの test が skipped になる
  - skipped が多い場合は cascade を先に疑う
- retry で通った flaky と、2 回失敗した unexpected を区別する
- local では通り CI で落ちる場合、移行前の commit でも落ちるなら環境 drift を候補に入れる
  - 例は同じ tag の docker image の rebuild である

## 使い分け

- plan review
  - 観点 1-8 を中心に使う
  - 実装前に壊れる箇所を除く
  - 観点 3 は必ず確認する。実装後に plan の主張をどう検証するかを見る
- code review
  - 観点 2-5 と 9 を中心に使う
  - gate / 設定 / 呼び出し元への追従を diff の外から探す
  - diff に現れない変更漏れを見つけることが reviewer の付加価値である
- 進め方の正本
  - review loop の round / Answer / Fixed 化は planning skill が持つ
  - CI failure の調査と test の書き方は、binding が指す repo 側の skill や文書が持つ
