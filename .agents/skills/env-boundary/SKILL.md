---
name: env-boundary
description: Prevent dev-environment values (origins, ports, hosts, absolute paths, secrets) from leaking into build artifacts, generated code, or production output. Use whenever writing or reviewing build scripts / codegen, adding a URL / port / hostname / origin literal, branching on dev vs prod, configuring CORS or crossorigin attributes, or when generated files (*.gen.*, dist output, feeds, sitemaps) embed any absolute URL. Trigger proactively — this class of bug ships silently and is only noticed in production.
---

# env-boundary

環境 (dev / prod / CI) で値が変わるものを、どの層で解決するかの規律。
実際に起きた事故: build script が `http://localhost:3000/...` を生成物に焼き込み、それが本番の RSS `<enclosure>` にまで到達した。生成物は環境を越えて運ばれるので、焼き込んだ瞬間に事故は時限式になる。

## 原則

**環境で変わる値は、build 時ではなく runtime に、単一のモジュールで解決する。**

- 生成物 (`*.gen.*`、bundle、feed、sitemap) には環境非依存のデータ (ファイル名、相対パス、ID) だけを入れる
- オリジン・ポート・ホスト名の解決は 1 つのヘルパーモジュールに集約する
- 複数の consumer (例: player と feed) が同じ値を必要とするなら、必ず同じヘルパーを共有する。片方だけ直って片方が残る事故を構造的に防ぐため

## 環境依存値の識別

コードに literal で書いた瞬間に疑うもの:

- オリジン / ホスト名 / ポート (`localhost:3000`、`127.0.0.1`、本番ドメイン直書き)
- 絶対ファイルパス (`/Users/...`、`/home/...`)
- 認証情報・トークン (これはそもそも書かない)
- 「dev では動くが prod で違う」挙動: CORS、cookie 属性、プロトコル (http/https)

## dev / prod 分岐の書き方

- 分岐には build で消える判定 (`import.meta.env.DEV` 等) を使い、**なぜ分岐が必要か**をコメントに書く。理由のない分岐は次の変更で壊される
- `crossorigin` 属性と CORS ヘッダは**組**で考える: 属性を付けるなら、全環境で相手サーバの `Access-Control-Allow-Origin` が自分のオリジンを許すかを確認する。dev のオリジン (localhost) は本番サーバの許可リストに普通いない
- 「dev だけ違う URL」を作るときは、相対パス (`/files/...`) を第一候補にする。相対ならポートが変わっても壊れない

## 検証 (実装したら必ず)

1. build を実行し、**配布物側**を機械検査する:
   ```sh
   grep -rn "localhost:\|127.0.0.1:" dist/
   ```
   ソースではなく配布物を見る。焼き込みはソースレビューをすり抜けても配布物には必ず現れる
2. 生成物を消費する**全系統**で確認する (UI で直っても feed が残っているかもしれない。consumer を列挙してから確認する)
3. 可能なら CI gate に昇格する。この検査は人間の注意力より grep の方が確実に強い分野で、gate 化した時点で再発が構造的に不可能になる

## レビュー観点

diff に絶対 URL・ポート番号・ホスト名の literal が現れたら、機械的に 3 問:

1. この値は**どの環境で**評価されるか (build 時か runtime か)
2. build 時なら、生成物は**別の環境に運ばれる**か (bundle / feed / 配布物なら Yes)
3. 同じ値を必要とする**他の consumer** はいないか
