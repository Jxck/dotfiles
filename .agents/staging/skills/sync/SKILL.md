---
name: sync
description: |
  ローカルの git 状態を、現在の branch の upstream と完全に同期させる workflow。
  未 commit の変更を commit し、fetch して必要なら rebase し、push して、ローカルとリモートの差分が 0 になるまで行う。
  「sync して」「git sync」「ローカルとリモートを同期して」で起動する。
  /sync check = ahead / behind と未 commit の有無を報告するだけで、commit / rebase / push は行わない。
  「sync 必要か確認して」「ずれてるか見て」で起動する。
---

# sync

ローカルと upstream を完全に同期させるための手順である。
「commit だけ」「push だけ」ではなく、未 commit -> fetch -> rebase -> push の全経路を 1 つの依頼として扱う。

## command

`/sync <subcommand>` の形式で起動する。

- 引数なし
  - 下記「手順」を最後まで実行する
- `check`
  - 手順 1-4 だけを行う
  - 結果を報告する
  - fetch は行う。commit / rebase / push は行わない

## repo 固有の値

操作対象の repo の root に `.agents/bindings/sync.md` があれば最初に読む。root は `git rev-parse --show-toplevel` で求める。

binding は次を定める。

- rebase の後に通す検証 command
- commit に含めない path
- push に承認が要る条件

binding が無い repo では次の既定で動く。

- 検証 command は repo の AGENTS.md / CLAUDE.md が定めるものを使う
  - 変更の種類ごとに定めがある場合は、今回の変更に対応するものを通す
  - 定めが無ければ検証なしで進める。その旨を報告する
- commit の対象は作業 tree の全変更とする
- push は承認なしで試みる

どの repo でも次の規約に従う。

- commit message は `commit-message` skill に従う
- 履歴は rebase で揃える。merge commit を作らない
- push は `--force-with-lease` で行う

## 手順

1. `git status --porcelain` で未 commit の変更を確認する
2. upstream を確定する
   - `git rev-parse --abbrev-ref --symbolic-full-name @{u}` が成功すれば upstream がある
   - remote は `git config branch.<現在の branch>.remote` で得る
   - remote 側の branch は `git config branch.<現在の branch>.merge` で得る
   - upstream が無い branch では何も変更せずに止まる。push 先を確認する
   - `check` の場合は、未 commit の有無と upstream が無いことを報告して終える
3. `git fetch <remote>` を実行する
4. ahead / behind を確認する
   - behind は `git log --oneline HEAD..@{u}` が示す。取り込むべき remote 側の commit である
   - ahead は `git log --oneline @{u}..HEAD` が示す。push すべき local 側の commit である
5. 未 commit の変更があれば commit する
   - `git diff` で内容を確認する
   - 機密情報の混入と、半端な debug 出力のような未完成の変更が無いかを見る。見つけたら commit せずに止まる
   - binding が commit に含めないと定めた path には触れない。stash も破棄もしない
   - 無関係な変更が混ざっている場合は、意味のある単位に分けて複数の commit にする
   - commit した内容の一覧を報告に含める。確認を待つために止まらない
6. behind が 1 件以上あれば `git rebase @{u}` を実行する
   - 作業 tree に未 commit の変更が残っている場合は rebase できない。rebase せずに止まり、状況を報告する
   - conflict が出たら自動で解決せずに止まる。対象 file と状況を報告して判断を仰ぐ
   - rebase の後に検証 command を通す
   - 検証が失敗したら push せずに止まる。結果を報告する
7. ahead が 1 件以上あれば `git push --force-with-lease <remote> HEAD:<remote 側の branch>` を実行する
   - 承認が要る場合は user に依頼する
   - 承認が得られない場合は再試行しない。commit と rebase までは完了していることを報告して push を保留する
8. 最終確認を行う
   - `git status --porcelain` が空であること
   - 手順 4 の ahead / behind が両方 0 であること
   - commit に含めなかった変更が残る場合は、差分 0 は未達と報告する

## してはいけないこと

- rebase の conflict を独断で解決する
- 内容を確認せずに未 commit の変更を commit する
- upstream の無い branch で push 先を推測する
- push の承認を得ずに再試行し続ける
- `git push --force` や `git reset --hard` のような、lease 付きの push より強い破壊的操作を代わりに使う
