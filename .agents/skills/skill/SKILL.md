---
name: skill
description: |
  skill を作る / 直す / 点検するためのメタ skill。global (dotfiles) と repo の二層を扱う。
  /skill new <name> = 新しい skill を規約どおりに作る。global に置くか repo に置くかの判定から始める。
  「skill にして」「これを skill 化して」「手順を残して」で起動する。
  /skill fix <name> = 既存 skill を規約に合わせて直す。
  「skill を直して」「skill を規約に合わせて」で起動する。
  /skill fix = 名前なしの場合は、監査で見つかった配線のずれと AGENTS.md との重複を直す。
  /skill list = global と現在の repo の skill を、subcommand と一行要約つきで一覧する。
  /skill check = skill の配置と AGENTS.md との整合を監査して報告する (書き換えない)。明示的に頼まれたときだけ行う。
  skill にすべきか、どちらの層に置くかの判断基準もここが持つ。
---

# skill

skill を作るための skill である。skill は、同種の作業を同じ品質で再現するための手順書である。単発の memo ではない。

## command

`/skill <subcommand>` の形式で起動する。

- `new <name>`
  - 下記「新規作成の手順」を実行する
- `fix <name>`
  - 下記「既存を直す手順」を実行する
- `fix`
  - 名前を付けない場合は、下記「配置を直す手順」を実行する
- `list`
  - global と現在の repo の `.agents/skills/` を走査する
  - 各 skill の層 / `name` / subcommand / 一行要約を返す
- `check`
  - 下記「監査」を実行する
  - finding を報告する
  - 書き換えない。修復は `fix` が担う
- 引数なし
  - 実行する command と対象 skill を確認してから進める

## repo 固有の値

操作対象の repo の root に `.agents/bindings/skill.md` があれば最初に読む。root は `git rev-parse --show-toplevel` で求める。

binding は次を定める。

- skill の配線の規約
- skill を書いた後に通す format の gate
- skill の一覧を持つ文書と、その更新の仕方

binding が無い repo では次の既定で動く。

- 配線は、repo の AGENTS.md に規約があればそれに従う
  - 無ければ、既にある配線と同じ形に合わせる
  - 配線が 1 つも無い repo では `.claude/skills/<name>` に skill ごとの symlink を張る
- format の gate は、repo の AGENTS.md / CLAUDE.md が定める検査を通す
  - 定めが無ければ gate なしで進める
- skill の一覧を持つ文書は、repo の文書を検索して見つかったものを更新する

## 二つの層

skill は置き場所で 2 つに分かれる。

- global
  - 正本は `~/dotfiles/.agents/skills/<name>/` に置く
  - home の `~/.claude/skills` と `~/.agents/skills` がここを指す
  - そのため全ての repo から見える
  - どの repo でも同じ手順で成立する skill を置く
- repo
  - 正本はその repo の `.agents/skills/<name>/` に置く
  - その repo の content / infra / 契約に結び付いた skill を置く

global に置く条件は次の 4 つで、全て満たす必要がある。

1. 本文が repo 固有の path / host / command / file 名を、手順の一部として持たない
2. 2 つ以上の repo で使う見込みがある
3. 公開してよい内容である。dotfiles は public repo である
4. 依存する他の skill / subagent / script が global 側に揃っている

1 つでも欠ければ repo に置く。事例としての言及は条件 1 に反しない。

global と repo に、別の実体で同じ `name` を置かない。
Claude Code は同名のとき global を優先し、repo 側を黙って隠す。Codex は両方を表示する。

## binding

global の skill は repo 固有の値を本文に持たない。その値は、使う側の repo の `.agents/bindings/<skill>.md` に置く。

- 場所は操作対象の repo の root 直下である
- global の skill は最初に binding の有無を確認する。あれば読む
- repo の AGENTS.md / README に既にある規約は binding に複製しない。binding からその節を名前で参照する
- binding が無い repo での既定の動作を、skill の本文に書く
- 既定を決められない値があるなら、変更を行う前に止まると書く

## そもそも skill にすべきか

次の条件では skill にする。

- 同じ種類の作業が繰り返される
- 手順に、事故を防ぐ順序や罠がある
  - 先に検査する必要がある
  - 特定の gate を忘れると検査が黙って抜ける
- 委譲の采配が決まっている
  - subagent に任せる作業と自分で行う作業を区別できる

次の条件では skill にしない。

- 一度きりの作業
  - plan に書く
- code 自体で表現できること
  - script にする
- 一般論や外部の知識
  - 既にある外部の skill か公式の文書を参照する
- その repo での採用方針だけ
  - repo の文書に書く

迷った場合は、次に同じ依頼が来たときに同じ品質で再現できる文書かで判断する。

## 規約

1. 実体を正本の directory の `SKILL.md` に置く
   - global では配線は要らない
   - repo では「repo 固有の値」の配線の規約に従う
   - Codex は repo の `.agents/skills` を直接読む。`.codex/skills` を持たない repo に新しく作らない
2. `name` を directory 名と一致させる
   - `docs` / `sync` のような短い名詞にする
   - `docs-sync` のような動詞を含む複合名は使わない。動詞は subcommand で表す
   - built-in や bundled の command、およびその alias と同じ名前を避ける
   - 例として Claude Code の `/review` は `/code-review` の alias である
3. `description` に起動条件を書く
   - 処理内容だけでは足りない。agent は `description` から起動を判断する
   - 起動する user の言い回しを含める
   - subcommand ごとに 1 行以上書く
   - 1,536 文字以内に収める。Claude Code は超えた分を切り捨てる
4. `## command` 節を必ず置く
   - subcommand の一覧を書く
   - 引数が無い場合の既定を明記する
   - 書き換えない `check` を持てる skill には持たせる
5. 手順は番号付きにする
   - 判断と実行を分ける
   - 全て通るまで完了としない gate を明記する
   - してはいけないことを列挙する。禁止事項が欠けると事故になる
   - subagent に委譲する作業を書く
   - 自分で行う作業も書く
6. source of truth を二重化しない
   - 規約が別の file にあれば、その正本を参照する
   - skill には手順と采配だけを書く
7. 長い skill は分割する
   - `SKILL.md` は入口に保つ
   - 詳細は同じ directory の別の `.md` に置く
   - `SKILL.md` から相対 link で参照する
8. 文章は `writing` skill の構造のルールに従う
   - 全角記号を使わない。矢印は `->` と書く
   - 日本語の文章と句読点は使える
   - 「repo 固有の値」の format の gate を通す
9. global の skill には `## repo 固有の値` 節を置く
   - binding が定める値を書く
   - binding が無い場合の既定を書く

## 新規作成の手順

1. `/skill list` で既存の skill との重複を確認する
   - 近い skill があれば subcommand の追加を検討する
   - skill を増やすほど選択の cost が上がるためである
2. 「二つの層」の 4 条件で、global に置くか repo に置くかを決める
3. 正本の directory に `SKILL.md` を規約どおりに書く
   - 実際に行った作業から手順を書き起こす
   - 想像で書かない。実績のある手順だけが再現性を持つ
4. repo に置いた場合は、規約 1 に従って配線する
5. 参照を追加する
   - skill の一覧を持つ文書に追記する
   - 新しい skill を参照すべき既存の skill や文書を探して追記する
6. 規約 8 の gate を通す

## 既存を直す手順

`/skill fix <name>` の手順である。

1. 規約 1-9 と照らして差分を出す
   - subcommand 化、path の追従、記述の重複の解消を行う
2. rename する場合は次の順に行う
   - skill ごとの symlink を持つ repo では、先に古い symlink を `unlink` で外す
   - `git mv` で directory を移す
   - frontmatter の `name` を新しい名前にする
   - skill ごとの symlink を持つ repo では、新しい名前の symlink を張る
   - directory を先に移すと symlink が壊れる
   - 壊れた symlink に `rm` を使うと `No such file or directory` で失敗する場合がある。2026-08-06 に実測した
3. 参照を追従させる
   - skill の一覧を持つ文書
   - 他の skill からの言及
   - AGENTS.md の記述
   - 日付付きの plan の過去の記述は書き換えない。歴史であるためである
4. 規約 8 の gate を通す

## 配置を直す手順

名前を付けない `/skill fix` の手順である。監査の finding を修復する。

1. 「監査」を実行して finding を出す
2. 配線を正本に合わせる
   - 欠けた link を張る
   - 余分な link と壊れた link を `unlink` で外す
3. AGENTS.md にある task 固有の rule を、対応する skill の正本へ移す
   - AGENTS.md にはその skill への参照だけを残す
   - repo 共通の rule は AGENTS.md に残す
4. 規約 8 の gate を通す
5. 移管 / 削除 / 共通化した点を短くまとめて報告する

## 監査

`/skill check` の内容である。対象は global と現在の repo の両方とする。
外部管理の skill は、`name` と配線だけを確認する。

`name` の一致、同名、配線の 3 つは `skill-check` で機械検査する。dotfiles の `bin/` にある command で、先頭の引数を global、以降を repo として扱う。

```sh
skill-check ~/dotfiles/.agents/skills "$(git rev-parse --show-toplevel)/.agents/skills"
```

次を確認し、blocker / major / minor に分けて報告する。

- 各 `SKILL.md` の frontmatter の `name` が directory 名と一致する
- global と repo に、別の実体で同じ `name` が無い
- repo の配線が正本と一致する
  - link の欠落、余分な link、宛先の違い、壊れた link を見る
- skill が参照する file / command / 他の skill / subagent が実在する
- binding が参照する AGENTS.md / README の節が実在する
- `description` が 1,536 文字以内である
- AGENTS.md と skill の間に、重複や矛盾や古い記述が無い
  - AGENTS.md には repo 共通の rule だけを残す
  - task 固有の rule は対応する skill に置く
- plan の置き場所、命名、参照の導線が planning skill と整合する

次は監査の対象にしない。

- 個別の plan の作成 / review / Fixed 化
  - planning skill が担当する
- MCP server の設定
- editor / formatter / shell の一般設定

## してはいけないこと

- 実績のない手順を書く
  - 「たぶんこうすれば動く」を skill にしない
  - skill は再現性を担保する。推測を固定すると事故が伝播する
- 規約や仕様を skill 側へ copy する
  - 二重化すると一方が古くなる。正本を参照する
- skill を乱立させる
  - 毎回どの skill を使うかの判断から始まる状態は失敗である
- global の skill に repo 固有の値を書く
  - binding に置く
- 日付付きの plan の歴史記述を書き換える
