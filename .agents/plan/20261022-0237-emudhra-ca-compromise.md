# Fixed Plan: eMudhra 中間 CA 秘密鍵漏えい (CVE-2026-111943) の conoha サーバ側対策

## TODO

実施順。sudo を要する手順はこの環境の agent から実行できない (`sudo -n true` が password を要求) ため、agent が実行できるものを先に行い、sudo 手順は Jxck が実行する。

- [x] 3-2 Homebrew: `ca-certificates` 2026-10-20 / `mise` 2026.10.17 / cask `claude-code` 2.1.304 (Claude, 04:19 JST 完了。brew ストア 124 件、emSign / AAA 0 件)
- [x] 3-3 mise: go 1.27.3 / node 26.12.1 / deno 2.9.8 (Claude, 04:27 JST 完了。`SSL_CERT_FILE` 方式は無効と判明し、Homebrew curl による独立再取得との一致確認に置き換え。詳細は 3-3 の「実施時の訂正」)
- [x] 3-4 rustup 1.29.2 (Claude, 04:27 JST 完了。static.rust-lang.org の sha256 と一致確認)
- [x] 4 章のうち sudo 不要の確認: brew ストア、版、check.sh (Claude, 04:35 JST 完了。brew 系 / node / go / deno は 12/12 REJECTED、system ストア系と bun が TRUSTED のまま `GATE: FAIL` = 3-1 待ち。4-R 参照)
- [x] 3-1 apt `ca-certificates` 20260816ubuntu0.26.04.1 (06:51 JST に unattended-upgrades が自動適用、手動実施は不要だった。Claude が 18:23 JST に 4-1 / 4-2 を確認: 両ストアとも emSign 0 件、hash link と pem 無し、conf 行は `!`)
- [x] 3-5 `ws.service` 再起動 (Jxck、18:07 JST 完了。MainPID 359714 の起動は `installs/node/latest -> 26.12.1` の切替 (04:23) より後で、ExecStart は latest 経由。root プロセスのため `/proc/<pid>/exe` の readlink は agent からは不可、4-R 参照)
- [x] 3-6 certbot drop-in (Jxck、18:08 JST 完了。`systemctl show` で `DropInPaths` に override.conf、`Environment` に両変数。3-1 後の httpx probe は `CERTIFICATE_VERIFY_FAILED` (Claude、18:28 JST))
- [x] 3-7 Claude Code の全セッション再起動 (Jxck、18:22 JST 完了。稼働プロセスは pid 369348 = 2.1.306 の 1 つのみ、ISRG 2 件 / emSign 0 件)
- [x] 4 章 acceptance 一式 (Claude、18:42 JST 完了。check.sh 再実行で `GATE: PASS` (`EXPECT_TRUSTED=bun`、ERROR 0)。4-1 〜 4-6 は 4-R 参照。ws の `/proc/<pid>/exe` と `journalctl -u ws` だけは root 権限が要り未確認)
- [x] HTML report の作成と commit (Claude、18:45 JST。`20261022-0237-emudhra-ca-compromise.html`)


## tldr

- eMudhra の中間 CA 8 件 (+ Sectigo cross-sign 8 件) の秘密鍵が証明書から復元可能で、誰でも任意サイトを偽装できる (https://emudhra.we-have-a-problem.com/)
- このサーバ (conoha, Ubuntu 26.04.1) では `emSign ECC Root CA - G3` 経由のチェーンを curl / wget / node / deno / bun / go / python / ruby / git の全てが信頼している (check.sh v2 ベースライン、ERROR 0 件)。`AAA Certificate Services` 経由は deno 以外で遮断済み
- 対策はトラストストアとランタイムの更新: Homebrew `ca-certificates` + `mise` + cask `claude-code`、mise で go / node / deno (`--no-prune`、node / deno は `--minimum-release-age 0s`)、rustup、apt `ca-certificates`、ws の再起動、certbot snap への systemd drop-in (撤去条件付き)、Claude Code セッションの再起動
- 未修正で残るのは Bun 1.4.2 (stable に修正無し、`SSL_CERT_FILE` も無視) と pnpm の同梱ルート束 (システムストアが空のときの fallback にのみ使われる)。Bun 製サービスは外向き TLS を行わない。稼働中の Claude Code セッションは起動時の 2.1.296 (emSign あり) で動いており、ディスク上の 2.1.306 (emSign 無し) に切り替えるには再起動が必要
- 受け入れ基準は check.sh v2 (3 値判定・陽性対照・必須 client と行数の検査・オフライン verify) の `GATE: PASS` (`EXPECT_TRUSTED=bun`) と、system / brew 両ストアからの `emSign ECC Root CA - G3` 消失。リポジトリへの変更はこの plan と README の TODO リンク、完了後の HTML report のみ


## Plan by Claude (Fable 5.1)

round 1 / round 2 のレビュー (末尾の `## Review by Claude Opus ...`) と `## Answer by Claude` の決定を反映した清書。レビュー体制: planning skill が代役に指定する `deep-reasoner` はこの環境に存在しないため、`general-purpose` agent (model: opus、独立コンテキスト) を代役レビュアーに使い、round 1 (request changes) と round 2 (approve、major 2 件は本文へ反映) の 2 巡を回した。

### 1. 背景と脅威モデル

- 2026-10-20 公開のアドバイザリ (https://emudhra.we-have-a-problem.com/) によると、eMudhra が 2025-04 に作成した中間 CA 証明書 8 件は鍵生成に欠陥があり、**証明書だけから秘密鍵を復元できる**。つまり公開情報だけで誰でも偽証明書を作れる
- 中間 CA は以下 4 つのルートにチェーンする (roots.json)
  - `emSign Root TLS CA - G3` / `emSign Root CS CA - G3`: Microsoft のみ収録 (このサーバには無い)
  - `AAA Certificate Services` (Sectigo cross-sign): Apple / Microsoft 収録、Mozilla / Chrome は削除済み
  - `emSign ECC Root CA - G3` (cross-sign): Mozilla / Apple / Chrome / Microsoft 全て収録。**このサーバで唯一露出しているルート**
- CA は 2026-10-18/19 に失効済みだが、失効情報 (CRL / OCSP) を見ないクライアント (CLI, ライブラリ, ランタイム) はソフトウェア更新が必要
- CT ログに登録が無いため、CT を強制するブラウザは攻撃対象外。影響するのはブラウザ以外の TLS クライアント、つまりこのサーバの outbound 通信全般
- 脅威: このサーバと外部サービス (Let's Encrypt, Cloudflare API, npm / Go / PyPI の各レジストリ, GitHub, api.anthropic.com 等) の経路上にいる攻撃者による中間者攻撃。確率は低いが、対策コストは低く、鍵は公開状態なので先延ばしにする理由が無い

### 2. 対象サーバの現状 (2026-10-22 02:20-04:10 JST 実測)

| クライアント | 参照するトラストストア | 現状 | 対策 |
| --- | --- | --- | --- |
| `/usr/bin/curl`, `/usr/bin/python3` (certifi は Debian patch でシステム参照), apt 版 git (gnutls), op (Go) | `/etc/ssl/certs/ca-certificates.crt` と `/etc/ssl/certs/<hash>.0` | `ca-certificates 20260601~26.04.1`。`emSign ECC Root CA - G3` を信頼。`Comodo_AAA_Services_root` は `/etc/ca-certificates.conf` で既に `!` | 3-1 |
| Homebrew curl (PATH 先頭), git, openssl, wget, python3 3.14.8 と pip 26.2.1 (truststore 経由), ruby 4.0.7 と `bin/` の ruby スクリプト | `$(brew --prefix)/etc/openssl@{3,4}/cert.pem` -> `etc/ca-certificates/cert.pem` (symlink) | `ca-certificates 2026-09-25`。`emSign ECC Root CA - G3` を含む (125 件) | 3-2 |
| mise 2026.10.3 (brew) | 汎用 HTTP は openssl@4 経由で system と brew の両ストア (strace で確認)。built-in npm backend は同梱ルート (webpki-root-certs) | npm backend は未修正。`.mise.toml` に `npm:` ツール 2 件 | 3-1, 3-2 (mise 2026.10.17) |
| node 26.11.1 (mise) | Node 同梱の NSS ルート | `tls.rootCertificates` に `emSign ECC Root CA - G3` あり | 3-3 |
| deno 2.9.7 (mise) | Deno 同梱 (webpki-roots) | AAA 系まで信頼しており、システムストアを見ていない | 3-3 |
| go 1.27.1 (mise) | Linux はシステムストア | システムストアの更新で直るが、1.27.3 は crypto/x509 で中間 CA 自体を遮断 (ルート非依存) | 3-1, 3-3 |
| pnpm 12.10.1 (mise) | rustls-platform-verifier + ネイティブストア (`SSL_CERT_FILE` を ISRG のみにすると registry.npmjs.org を拒否、実測)。ストアが空か読めないときだけ同梱ルート束 (emSign 入り、12.14.0 でも未修正) に fallback | 通常時はシステムストア依存 | 3-1 (fallback は 7 章で追跡) |
| bun 1.4.2 (mise) | Bun 同梱 (121 件) | `SSL_CERT_FILE` を無視 (実測)。`--use-system-ca` は受理するが追加のみ。stable の最新 1.4.3 (2026-10-10) に修正は無い (PR #46159 は main へ 2026-10-20 merge) | 据え置き (7 章) |
| Claude Code native 版 `~/.local/bin/claude` -> `~/.local/share/claude/versions/2.1.306` (Bun v1.4.4) | 同梱ルート | ディスク上の 2.1.306 は strings で `ISRG Root X1` 2 件 / `emSign ECC Root CA - G3` 0 件 (静的に修正済み)。**稼働中のセッション (この plan を書いているプロセス, pid 232138, 02:16:58 起動) の `/proc/<pid>/exe` は 2.1.296 (Bun v1.4.3) で、emSign 2 件 / ISRG 2 件**。自動更新はディスク上の版を差し替えただけ | 3-7 (再起動) |
| Claude Code Homebrew cask 2.1.231 (`$(brew --prefix)/bin/claude`, Bun v1.4.0) | 同梱ルート | PATH 上で shadow され未使用。レビュアーの PEM 抽出で 121 件中に `emSign ECC Root CA - G3` あり。Linux の cask は Brewfile (`if OS.mac?` 内) にも `update.sh` (`--formula`) にも管理されておらず、手で入れたもの | 3-2 (cask 2.1.304)、整理は TBD-6 |
| rustup 1.29.1 | `/etc/ssl/certs/<hash>.0` (strace で確認)。同梱ルート名は無し | システムストア依存 | 3-1, 3-4 |
| cargo (rustup 配布) | `/usr/lib/ssl/cert.pem` -> システムストア (strace で確認) | システムストア依存 | 3-1 |
| gh 等 Homebrew の Go 製バイナリ | システムストア | システムストア依存 | 3-1 |

ベースライン (check.sh v2, `baseline-v2-20261022-0344.txt`, 変更前): emSign 系 6 ホストは curl (brew / system) / wget / node / bun / deno / go / python (brew / system) / ruby / git (brew / apt) の全てが TRUSTED (各 6)。AAA 系 6 ホストは deno だけが TRUSTED (deno は 12/12)。system / brew 両ストアの `openssl verify` は emSign 系チェーンを OK にする (各 6)。陽性対照は全クライアント TRUSTED、ERROR 0 件、`GATE: FAIL` (期待どおり)。pnpm の native-store probe は REJECTED (正常)。

#### サービス側の確認 (systemd で稼働中のもの)

| サービス | 実体 | outbound TLS | 判断 |
| --- | --- | --- | --- |
| h2o | `~/develop/jxck.io/.h2o/local/bin/h2o` | `proxy.reverse.url` に https は無し、`proxy.ssl.*` 未設定、`ocsp-update-interval: 0` | 対象外。同梱 `share/h2o/ca-bundle.crt` (129 件) に `emSign ECC Root CA - G3` が残るので、将来 https upstream を proxy するなら要更新 |
| ws | `mise/installs/node/latest/bin/node server.js` | `server.js` に https 呼び出し無し | node 更新後に再起動 (バイナリ差し替え反映のため) |
| mozaic.fm / vtt.mozaic.fm | `mise/installs/bun/latest/bin/bun .dist/main.js` | `fetch(` は hono 内部 (リクエストハンドラ) のみ、外部 URL への呼び出し無し | 対象外 (Bun 更新時に再起動) |
| snap certbot 5.8.0 (+ certbot-dns-cloudflare) | snap 同梱 python 3.12。certifi 2026.07.22 を内蔵 (両 snap とも `emSign ECC Root CA - G3` を含む)。certbot 本体は requests、dns plugin は cloudflare 5.6.0 + httpx 0.28.1 | ACME (`acme-v02.api.letsencrypt.org`) と Cloudflare API (API token を送る) | **露出あり**。snap に更新は無い。3-6 で drop-in |
| unattended-upgrades | `resolute-security` を許可。`apt-daily-upgrade.timer` の次回は 2026-10-22 06:50 JST | - | 放置でも `ca-certificates` は 06:50 に自動適用される見込み。3-1 を手動で行う場合、重なったら dpkg lock の解放を待つ |

### 3. 実施手順 (このサーバ上)

当初の順序は 3-1 (apt) -> 3-2 (brew) -> 3-3 (mise) だったが、agent から sudo が使えないため、agent が実行できる 3-2 -> 3-3 -> 3-4 を先に行う。3-3 / 3-4 のダウンロードは未修正の system ストアに依存しないよう、修正済みの brew ストアだけを `SSL_CERT_FILE` で指定して行う (rustls-native-certs / rustls-platform-verifier は `SSL_CERT_FILE` / `SSL_CERT_DIR` が設定されていればそれだけを読む。事前に 4-4 の mise probe で拒否されることを確認してから使う)。3-2 自体のダウンロードは更新前の brew ストアで行うしかない (bootstrap)。

#### 3-2. Homebrew ストア、mise 本体、Claude Code cask (Claude)

```sh
HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade ca-certificates mise
# -> ca-certificates 2026-09-25 -> 2026-10-20, mise 2026.10.3 -> 2026.10.17 (dry-run でこの 2 件のみ)
brew upgrade --cask claude-code
# -> 2.1.231 -> 2.1.304 (shadow されている cask 側も古いルートを持たない状態にする)
```

- ca-certificates formula (HEAD) は SPKI SHA256 で `AAA Certificate Services`, `emSign Root TLS CA - G3`, `emSign ECC Root CA - G3` を除外し、Linux では post-install でシステム bundle と Mozilla bundle を結合する際にも同じ除外を適用する (確認は GitHub raw と `brew info --json=v2` で行う。`brew cat` は developer mode を on にするので使わない)
- mise 2026.10.17 (2026-10-21): "The built-in npm backend no longer trusts the eight eMudhra intermediate CA certificates" (`webpki-root-certs` 1.0.10, `rustls-webpki` 0.103.16)
- `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1` を付けない場合、dependents 21 件 (openssl@3, curl, ffmpeg 等) の upgrade が連鎖する。PEM の差し替えに再ビルドは不要なので付ける。残りは検証完了後に通常運用の `update.sh` で上げる。`brew upgrade` は auto-update を伴うので、実施時に dry-run より新しい版が来うる
- python@3.14 は上げない。pip 26.2.1 は truststore が常時有効 (`cmdoptions.py`: "always on since 24.2") で Homebrew の `cert.pem` を使うため、ca-certificates の更新で足りる。3.14.8_3 は openssl@4 への切り替えを伴い、本件と無関係
- 効果範囲: Homebrew の curl / git / openssl / wget / python3 (pip 含む) / ruby、mise の汎用 HTTP と npm backend、cask 側 Claude Code

#### 3-3. ランタイム (mise) (Claude)

```sh
B=/home/linuxbrew/.linuxbrew; EMPTY=$(mktemp -d)
export SSL_CERT_FILE=$B/etc/ca-certificates/cert.pem SSL_CERT_DIR=$EMPTY   # 3-2 後の brew ストアだけを使う (この手順の間だけ)
mise upgrade --dry-run --no-prune go                                      # Would install go@1.27.3
mise upgrade --no-prune go
mise upgrade --dry-run --no-prune --minimum-release-age 0s node deno      # Would install node@26.12.1 / deno@2.9.8
mise upgrade --no-prune --minimum-release-age 0s node deno
unset SSL_CERT_FILE SSL_CERT_DIR
mise ls node deno go                                                      # 26.12.1 / 2.9.8 / 1.27.3 が active
ls -la ~/.local/share/mise/installs/node/latest                           # -> ./26.12.1
git -C ~/dotfiles diff --stat -- .mise.toml                               # 変更なし
```

- `.mise.toml` は `latest` 指定なので `--bump` は付けない。`.mise.toml` は変更しない
- node 26.12.1 と deno 2.9.8 は mise 既定の `minimum_release_age` (24h) により eligible 前 (node 2026-10-22 09:00 JST, deno 2026-10-23 00:28 JST) で、既定のままだと node は 26.12.0 (修正を含まない) に上がる。本件に限り `--minimum-release-age 0s` を明示する (設定ファイルは変えない一回限りの上書き。09:00 JST 以降に実施する場合 node には不要)。理由: 対象が本インシデントに対する vendor のセキュリティリリース (node 26.12.1 は nodejs.org の index で `security: true`) であり、取得経路 (ストア) を直してから取るため。24h 待機の目的 (直後の撤回リスク) より修正の先送りの方が不利
- `--no-prune`: mise 既定 (`upgrade.auto_prune = true`, `prune_after = 24h`) では旧版が 24h 後に自動削除される。ロールバック余地を残すため付け、旧版の削除は検証完了後の `update.sh` (`mise prune -y`) に任せる
- 修正内容の根拠
  - go 1.27.3 / 1.26.10: CVE-2026-111943。crypto/x509 の Verify が対象中間 CA を含むチェーンを返さない (golang-announce)
  - deno 2.9.8 (2026-10-21): `fix(tls): distrust compromised eMudhra certificate authorities` (#37046)
  - node 26.12.1 (2026-10-21, security release): ルート証明書を NSS 3.131.1 に更新し、blocked public key を含むチェーンを拒否
- Bun 1.4.2 は据え置き (7 章)

**実施時の訂正 (04:25 JST)**: 4-4 の mise probe を `SSL_CERT_FILE=<brew cert.pem> SSL_CERT_DIR=<空 dir>` 付きで実行しても emSign 系ホストに `200 OK` が返り、mise 2026.10.17 の汎用 HTTP は `SSL_CERT_FILE` では制限できないことが分かった (system ストアも読み続ける)。そのため「修正済み brew ストアだけで取得する」は成立せず、次に置き換えた:

- mise / rustup の更新はそのまま実行する (取得時点では system ストアが emSign を信頼しているので、経路改ざんの可能性は 3-2 の bootstrap と同じ扱い)
- 直後に、修正済みストアを使う Homebrew curl (emSign 系テストホストを `rc=60` で拒否することを確認済み) で同じ配布物を独立に再取得し、インストール済みツリーと内容ハッシュで比較する。tmpfs の容量制約から展開はせず、`tar --to-command=sha256sum` でアーカイブ内の全ファイルをハッシュ化して `find | sha256sum` の結果と突き合わせる (node: tarball sha256 も SHASUMS256.txt と照合、go: go.dev の index の sha256 と照合、deno: zip 内の `deno` の sha256、rustup: `rustup-init.sha256`)。不一致があれば経路改ざんの疑いとして該当ツールを `mise uninstall` し、3-1 後に取り直す
- 比較結果は 4 章の実施記録と report に残す

#### 3-4. rustup (Claude)

```sh
SSL_CERT_FILE=$B/etc/ca-certificates/cert.pem SSL_CERT_DIR=$EMPTY rustup self update   # 1.29.1 -> 1.29.2
```

- rustup はシステムストアを読むので 3-1 でも直るが、アドバイザリは rustup 1.29.2 と rustls-webpki 0.103.16 自体を patched version に挙げている (ルートに依存しない遮断が入っている可能性)。費用が小さいので実施する

#### 3-1. システムストア (apt) (sudo、Jxck)

```sh
sudo apt-get install --only-upgrade ca-certificates
# -> 20260816ubuntu0.26.04.1 (resolute-security)。dry-run で変更はこの 1 パッケージのみ
```

- Launchpad #2171507 (Fix Released 2026-10-20): `emSign ECC Root CA - G3` を blacklist に追加。併せて Mozilla bundle 2.90 へ更新 (SECOM / Telia の 4 ルート追加、Atos TrustedRoot 2011 / Entrust Root CA / SecureSign Root CA12 / ePKI Root CA の 4 ルート削除)
- `/etc/ca-certificates.conf` は conffile ではなく debconf (`trust_new_crts: yes`) と postinst が管理する。手動編集していないので prompt は出ない想定
- 効果範囲: `/usr/bin/curl`, `/usr/bin/python3`, apt 版 git, go 1.27.1 のバイナリ, pnpm, rustup, cargo, op / gh 等 Go 製バイナリ, mise の汎用 HTTP

#### 3-5. サービス再起動 (sudo、Jxck)

```sh
sudo systemctl restart ws.service
systemctl is-active h2o ws mozaic.fm vtt.mozaic.fm
readlink /proc/$(systemctl show -p MainPID --value ws)/exe   # .../installs/node/26.12.1/bin/node
```

- `installs/node/latest` は mise が張る symlink で、upgrade 後に新版へ向く。稼働中プロセスは旧バイナリを掴んだままなので再起動が必要
- mozaic.fm / vtt.mozaic.fm は Bun を更新しないので再起動しない。h2o は無関係

#### 3-6. certbot snap (暫定、撤去条件付き) (sudo、Jxck)

事前 probe (読み取りのみ。`certbot renew --dry-run` は Cloudflare に TXT を書くので使わない。`show_account` は `newAccount` に `onlyReturnExisting: true` を POST するだけでアカウントを作らない):

```sh
# requests 経路: snap run 経由で env が届くことの実証
sudo REQUESTS_CA_BUNDLE=/nonexistent certbot show_account                      # 失敗すること
sudo REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt certbot show_account # 成功すること
# httpx 経路 (dns-cloudflare が使う)。sudo 不要
PYC=$(ls -d /snap/certbot-dns-cloudflare/current/lib/python3.*/site-packages | head -1)
ISRG=$(mktemp); cp /etc/ssl/certs/ISRG_Root_X1.pem $ISRG
PYTHONPATH=$PYC /snap/certbot/current/bin/python3 -c 'import httpx; print(httpx.get("https://dv-g3b-emudhra.we-have-a-problem.com/").status_code)'                       # certifi 経由: 200 (snap 側が未修正)
SSL_CERT_FILE=$ISRG PYTHONPATH=$PYC /snap/certbot/current/bin/python3 -c 'import httpx; print(httpx.get("https://dv-g3b-emudhra.we-have-a-problem.com/").status_code)'   # 陰性対照: 例外 (httpx が SSL_CERT_FILE を読む証拠)
SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt PYTHONPATH=$PYC /snap/certbot/current/bin/python3 -c 'import httpx; print(httpx.get("https://dv-g3b-emudhra.we-have-a-problem.com/").status_code)'   # 3-1 後: 例外 (CERTIFICATE_VERIFY_FAILED)
```

drop-in:

```sh
sudo mkdir -p /etc/systemd/system/snap.certbot.renew.service.d
printf '[Service]\nEnvironment=REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt\nEnvironment=SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt\n' | sudo tee /etc/systemd/system/snap.certbot.renew.service.d/override.conf
sudo systemctl daemon-reload
systemctl show -p Environment snap.certbot.renew.service   # 両変数が出ること
```

- 対象は `snap.certbot.renew.timer` 経由の自動更新のみ。手動で certbot を実行する場合は撤去までの間 `sudo REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt certbot ...` とする
- probe の `PYTHONPATH` は plugin snap の certifi を先に見るが、実運用では certbot が `sys.path.extend` で plugin を後ろに足すため certbot snap 側の certifi が使われる (現状は同版)。撤去判断は certbot snap 側で行う
- 撤去条件: `grep -c 'emSign ECC Root CA - G3' /snap/certbot/current/lib/python3.*/site-packages/certifi/cacert.pem` が 0 になったら (PyPI の certifi 2026.10.18 以降は 0 件) `sudo systemctl revert snap.certbot.renew.service`。snap は自動 refresh されるので `update.sh` 実行時に確認する
- この drop-in はリポジトリで管理しない (撤去前提の一時措置。`~/develop/jxck.io/.systemd/` に certbot 関連の unit は無く、既存の drop-in も無い (`DropInPaths=` 空) ので `systemctl revert` が他を巻き込まない)。撤去を忘れても apt 管理のシステムストアを指すだけで害は無い。状態変更は本 plan と report に記録する

#### 3-7. Claude Code セッションの再起動 (Jxck)

- 自動更新はディスク上の `~/.local/bin/claude` の向き先を変えるだけで、起動済みのセッションは起動時点のバイナリ (2.1.296, emSign あり) で動き続ける。全ての Claude Code セッション (この plan を書いているセッションを含む) を終了して起動し直す。Claude は自分自身を再起動できないので owner は Jxck
- 完了判定は 4-4 (稼働中の全 `claude` プロセスの実体が emSign 0 件の版)

### 4. 検証 (acceptance)

完了判定は Claude (実施者) が 4-1 から 4-6 を全て満たしたことを確認し、結果を report に転記した時点。3-1 より前に実行した場合は system ストア側 (curl(system), python(system), git(apt), go 1.27.1 以前, openssl(system store)) が TRUSTED のまま `GATE: FAIL` になるのが期待値で、それは「未完」を意味する。

4-1. ストアの中身

```sh
for f in /etc/ssl/certs/ca-certificates.crt /home/linuxbrew/.linuxbrew/etc/ca-certificates/cert.pem; do
  echo "$f: $(openssl crl2pkcs7 -nocrl -certfile $f | openssl pkcs7 -print_certs -noout | grep -c 'CN *= *emSign ECC Root CA - G3')"
done                                                                   # 両方 0
ls -la /etc/ssl/certs/14bc7599.0 /etc/ssl/certs/emSign_ECC_Root_CA_-_G3.pem 2>&1   # どちらも存在しない
grep -n 'emSign_ECC_Root_CA_-_G3' /etc/ca-certificates.conf                         # 行頭が !
```

4-2. 版 (mise 管理のものは PATH に版付きディレクトリが残っている可能性があるので shims か `mise ls` で見る。期待値は「実施直前の dry-run の版以上」)

```sh
dpkg -l ca-certificates | grep '^ii'                                   # 20260816ubuntu0.26.04.1
brew list --versions ca-certificates mise                               # 2026-10-20 以上 / 2026.10.17 以上
brew list --cask --versions claude-code                                 # 2.1.304 以上
S=~/.local/share/mise/shims; $S/node -v; $S/go version; $S/deno --version | head -1; mise ls node deno go   # v26.12.1 / go1.27.3 / 2.9.8
rustup --version                                                        # 1.29.2
```

4-3. 実通信: check.sh v2 を実行し `GATE: PASS` であること (`EXPECT_TRUSTED=bun` を指定し、bun の emSign 系 6 ホスト TRUSTED は残存リスクとして記録する)。GATE は必須 client 16 種の全てについて「行数 = テストホスト数 (pnpm(native-store) は 1)、ERROR = 0、陽性対照 = TRUSTED、`EXPECT_TRUSTED` 以外は TRUSTED = 0」を検査する。openssl オフライン行 (system / brew) も必須 client に含まれる。pnpm の per-host 行は修正前は emSign 系ホストが無応答で ERROR になる (fail-closed)。修正後は TLS 失敗が即時に返り REJECTED になるはず

```sh
EXPECT_TRUSTED=bun ./check.sh --chains <chains.zip を展開した dir (12 個の .pem がある dir)>
```

4-4. 個別 probe

```sh
# mise の汎用 HTTP: 置換先 (we-have-a-problem.com) への行に 200 OK が無く、同ホストへの certificate エラー行があること
# (置換先が失敗すると deno.com へ fallback してそちらの 200 OK が出るので、ホスト名で読み分ける)
MISE_CACHE_DIR=$(mktemp -d) MISE_URL_REPLACEMENTS='{"https://mise-versions.jdx.dev":"https://dv-g3b-emudhra.we-have-a-problem.com"}' MISE_VERBOSE=1 mise ls-remote deno 2>&1 | grep -E 'we-have-a-problem|certificate' | head -4
# mise の npm backend はテストホストが無応答で実通信 probe が成立しないため、版 (2026.10.17 以上) でのみ確認する
# Claude Code: 稼働中の全プロセスの実体が emSign 0 件の版であること (ディスク上の旧版は判定対象外)
for p in $(pgrep -x claude); do e=$(readlink /proc/$p/exe); echo "pid=$p $e ISRG=$(strings $e | grep -c 'ISRG Root X1') emSignG3=$(strings $e | grep -c 'emSign ECC Root CA - G3')"; done
for c in $(readlink -f ~/.local/bin/claude) $(readlink -f /home/linuxbrew/.linuxbrew/bin/claude); do echo "$c ISRG=$(strings $c | grep -c 'ISRG Root X1') emSignG3=$(strings $c | grep -c 'emSign ECC Root CA - G3')"; done   # ISRG >= 1 (検索が有効) かつ emSignG3 = 0
# certbot: 3-6 の probe と systemctl show の結果
```

4-5. サービス: `systemctl is-active h2o ws mozaic.fm vtt.mozaic.fm` が全て active、`readlink /proc/$(systemctl show -p MainPID --value ws)/exe` が `installs/node/26.12.1/bin/node`、`curl -sI https://jxck.io/ | head -1` が 200、`journalctl -u ws -n 5` にエラーが無い

4-6. 副作用 (削除された 4 ルートの影響): 主要 outbound 先に brew curl と system curl で到達できること (2xx / 3xx / 4xx のいずれか。証明書エラー `rc=60` が無いこと)

```sh
for h in acme-v02.api.letsencrypt.org api.cloudflare.com registry.npmjs.org proxy.golang.org pypi.org github.com ghcr.io formulae.brew.sh nodejs.org dl.deno.land static.rust-lang.org index.crates.io rubygems.org api.anthropic.com; do
  printf '%-32s brew=%s system=%s\n' $h "$(/home/linuxbrew/.linuxbrew/opt/curl/bin/curl -sS -o /dev/null -w '%{http_code}' --max-time 15 https://$h/ 2>&1 | tail -c 3)" "$(/usr/bin/curl -sS -o /dev/null -w '%{http_code}' --max-time 15 https://$h/ 2>&1 | tail -c 3)"
done
```

注記: Bun の `tls.getCACertificates("system")` は既定の検証に使われる `"bundled"` と別物なので、apt 後に `"system"` から emSign が消えても Bun が直った根拠にはならない。

#### check.sh v2 (scratchpad に置いて実行。リポジトリには入れない)

使い方: `check.sh`, `gocheck/main.go`, `gocheck/go.mod` を同じディレクトリに置き、`chains.zip` (https://emudhra.we-have-a-problem.com/chains.zip) を展開した `chains/` (12 個の .pem がある dir) を `--chains` で渡す (必須)。`--quick` は dv-g3b の 2 ホストのみ。所要時間は約 4 分 (修正前は pnpm の無応答待ちで +3 分)。

```sh
#!/usr/bin/env zsh
# eMudhra 中間 CA 漏えい (2026-10) の信頼状態チェック
#   usage: check.sh [--quick] [--chains DIR]
#   行形式: client<TAB>version<TAB>host<TAB>RESULT(detail)
#   RESULT: TRUSTED  = チェーンを信頼した (悪い)
#           REJECTED = 証明書エラーで拒否した (良い)
#           ERROR    = 証明書と無関係な失敗 (DNS, timeout, スクリプト不備)。gate 不成立
#   陽性対照 (POSITIVE) は必ず TRUSTED になること。EXPECT_TRUSTED に列挙した client は
#   未修正として TRUSTED を許容する (例: EXPECT_TRUSTED="bun")
set -u
B=/home/linuxbrew/.linuxbrew
SHIMS=$HOME/.local/share/mise/shims
DIR=${0:A:h}
POS=valid-isrgrootx1.letsencrypt.org
CHAINS=""
QUICK=0
while (( $# )); do case $1 in --quick) QUICK=1;; --chains) shift; CHAINS=$1;; esac; shift; done
[[ -d $CHAINS ]] || { print -u2 -- "--chains DIR is required (dir with the 12 chain .pem files)"; exit 2; }

hosts=()
if (( QUICK )); then
  hosts=(dv-g3b-emudhra.we-have-a-problem.com dv-g3b-aaa-emudhra.we-have-a-problem.com)
else
  for t in dv ov ev; do for g in g3b g3c; do
    hosts+=("$t-$g-emudhra.we-have-a-problem.com" "$t-$g-aaa-emudhra.we-have-a-problem.com")
  done; done
fi
all=($hosts $POS)

typeset -A T R E P
row() { # client version host result
  print -- "$1\t$2\t$3\t$4"
  local k=$1 res=${4%%\(*}
  if [[ $3 == $POS ]]; then P[$k]=$res; return; fi
  case $res in TRUSTED) T[$k]=$(( ${T[$k]:-0} + 1 ));; REJECTED) R[$k]=$(( ${R[$k]:-0} + 1 ));; *) E[$k]=$(( ${E[$k]:-0} + 1 ));; esac
}
classify_msg() { # msg -> REJECTED/TRUSTED/ERROR by keyword
  local m=$1
  if [[ $m == *(certificate|CERT_|UNABLE_TO_|UnknownIssuer|x509:|SSLError|verify failed)* ]]; then echo REJECTED
  elif [[ $m == *(is this a git repository|repository|Not Found|not found|404|JSON|Unexpected|DECODE_ERROR)* ]]; then echo TRUSTED
  else echo ERROR; fi
}

v_curl_b=$($B/opt/curl/bin/curl --version | head -1 | awk '{print $2}')
v_curl_s=$(/usr/bin/curl --version | head -1 | awk '{print $2}')
v_wget=$($B/bin/wget --version | head -1 | awk '{print $3}')
v_node=$($SHIMS/node -v); v_bun=$($SHIMS/bun --version); v_deno=$($SHIMS/deno --version | head -1 | awk '{print $2}')
v_go=$($SHIMS/go version | awk '{print $3}'); v_pnpm=$($SHIMS/pnpm --version 2>/dev/null | tail -1)
v_py_b=$($B/bin/python3 -c 'import platform;print(platform.python_version())'); v_py_s=$(/usr/bin/python3 -c 'import platform;print(platform.python_version())')
v_ruby=$($B/bin/ruby -e 'print RUBY_VERSION'); v_git_b=$($B/bin/git --version | awk '{print $3}'); v_git_s=$(/usr/bin/git --version | awk '{print $3}')

for h in $all; do
  u="https://$h/"
  for pair in "curl(brew):$B/opt/curl/bin/curl:$v_curl_b" "curl(system):/usr/bin/curl:$v_curl_s"; do
    name=${pair%%:*}; rest=${pair#*:}; bin=${rest%%:*}; ver=${rest#*:}
    out=$($bin -sS -o /dev/null -w '%{http_code}' --max-time 20 "$u" 2>&1); rc=$?
    if (( rc == 0 )); then row $name $ver $h "TRUSTED(http $out)"; elif (( rc == 60 )); then row $name $ver $h "REJECTED(rc=60)"; else row $name $ver $h "ERROR(rc=$rc ${out:0:60})"; fi
  done
  out=$($B/bin/wget -O /dev/null --timeout=20 --tries=1 "$u" 2>&1); rc=$?
  if (( rc == 0 )); then row "wget(brew)" $v_wget $h "TRUSTED"; elif (( rc == 5 )); then row "wget(brew)" $v_wget $h "REJECTED(rc=5)"; else row "wget(brew)" $v_wget $h "ERROR(rc=$rc)"; fi

  out=$($SHIMS/node -e 'fetch(process.argv[1]).then(r=>console.log("TRUSTED(http "+r.status+")"),e=>{const c=e.cause?.code||e.code||e.message; console.log((/CERT|UNABLE_TO|certificate/.test(c)?"REJECTED":"ERROR")+"("+c+")")})' "$u" 2>&1 | tail -1); row node $v_node $h "$out"
  out=$($SHIMS/bun -e 'try{const r=await fetch(Bun.argv.at(-1));console.log("TRUSTED(http "+r.status+")")}catch(e){const c=e.code||e.message; console.log((/CERT|UNABLE_TO|certificate/.test(c)?"REJECTED":"ERROR")+"("+c+")")}' "$u" 2>&1 | tail -1); row bun $v_bun $h "$out"
  out=$($SHIMS/deno eval 'try{const r=await fetch(Deno.args[0]);console.log("TRUSTED(http "+r.status+")")}catch(e){const m=[e.message,e.cause&&(e.cause.message||String(e.cause))].filter(Boolean).join(": ").split("\n")[0]; console.log((/certificate|UnknownIssuer|CertRevoked|distrust/i.test(m)?"REJECTED":"ERROR")+"("+m.slice(-90)+")")}' "$u" 2>&1 | tail -1); row deno $v_deno $h "$out"
  out=$(cd $DIR/gocheck && $SHIMS/go run . "$u" 2>&1 | tail -1); row go $v_go $h "$out"
  for pair in "python(brew):$B/bin/python3:$v_py_b" "python(system):/usr/bin/python3:$v_py_s"; do
    name=${pair%%:*}; rest=${pair#*:}; bin=${rest%%:*}; ver=${rest#*:}
    out=$($bin -I -c 'import sys,ssl,urllib.request,urllib.error
try:
    r=urllib.request.urlopen(sys.argv[1],timeout=20); print("TRUSTED(http %d)"%r.status)
except urllib.error.URLError as e:
    print(("REJECTED" if isinstance(e.reason, ssl.SSLCertVerificationError) else "ERROR")+"(%s)"%str(e.reason)[:70])
except Exception as e: print("ERROR(%s)"%str(e)[:70])' "$u" 2>&1 | tail -1); row $name $ver $h "$out"
  done
  out=$($B/bin/ruby -rnet/http -e 'begin; r=Net::HTTP.get_response(URI(ARGV[0])); puts "TRUSTED(http #{r.code})"; rescue OpenSSL::SSL::SSLError => e; puts((e.message =~ /certificate verify failed/ ? "REJECTED" : "ERROR")+"(#{e.message[0,70]})"); rescue => e; puts "ERROR(#{e.class})"; end' "$u" 2>&1 | tail -1); row "ruby(brew)" $v_ruby $h "$out"
  out=$(timeout 30 $SHIMS/pnpm --registry "$u" view nonexistent-pkg-zz-123 version 2>&1 | grep -vE '^\s*$' | head -6 | tr '\n' ' '); rc=$?
  if [[ -z $out ]]; then row pnpm $v_pnpm $h "ERROR(no output within 30s)"; else row pnpm $v_pnpm $h "$(classify_msg "$out")(${out:0:90})"; fi
  for pair in "git(brew):$B/bin/git:$v_git_b" "git(apt):/usr/bin/git:$v_git_s"; do
    name=${pair%%:*}; rest=${pair#*:}; bin=${rest%%:*}; ver=${rest#*:}
    out=$(GIT_TERMINAL_PROMPT=0 $bin ls-remote "$u" 2>&1 | head -1); row $name $ver $h "$(classify_msg "$out")(${out:0:70})"
  done
done

# pnpm (rustls + native store): emSign 系テストホストは pnpm に対して応答を返さず 60s 超でハングするため、
# per-host probe の代わりに「SSL_CERT_FILE を ISRG のみにすると registry.npmjs.org (DigiCert 系) を拒否する」
# ことでネイティブストア参照を確認する。emSign の信頼可否はシステムストアの openssl 行で判定する
cp /etc/ssl/certs/ISRG_Root_X1.pem $DIR/isrg-only.pem
out=$(SSL_CERT_FILE=$DIR/isrg-only.pem timeout 60 $SHIMS/pnpm --registry https://registry.npmjs.org/ view left-pad version 2>&1 | grep -vE '^\s*$' | head -6 | tr '\n' ' ')
res=$(classify_msg "$out"); [[ $res == TRUSTED ]] && res="TRUSTED" ; row "pnpm(native-store)" $v_pnpm "registry.npmjs.org" "$res(${out:0:90})"
out=$(timeout 60 $SHIMS/pnpm --registry "https://$POS/" view nonexistent-pkg-zz-123 version 2>&1 | grep -vE '^\s*$' | head -6 | tr '\n' ' ')
row "pnpm(native-store)" $v_pnpm $POS "$(classify_msg "$out")(${out:0:90})"

if [[ -n $CHAINS && -d $CHAINS ]]; then
  for pair in "openssl(system store):/etc/ssl/certs/ca-certificates.crt:/usr/bin/openssl" "openssl(brew store):$B/etc/ca-certificates/cert.pem:$B/bin/openssl"; do
    name=${pair%%:*}; rest=${pair#*:}; store=${rest%%:*}; bin=${rest#*:}
    ver=$($bin version | awk '{print $2}')
    for f in $CHAINS/*.pem; do
      h=${${f:t}%.pem}; [[ $QUICK == 1 && $h != dv-g3b-* ]] && continue
      out=$($bin verify -CAfile $store -untrusted $f $f 2>&1); reason=$(print -- "$out" | grep -E '^error [0-9]+ at' | head -1)
      if [[ $out == *": OK"* ]]; then row $name $ver $h "TRUSTED(verify OK)"
      elif [[ $out == *(unable to get local issuer|unable to get issuer|self-signed|unknown)* ]]; then row $name $ver $h "REJECTED(${reason:0:70})"
      else row $name $ver $h "ERROR(${${reason:-$out}:0:70})"; fi
    done
  done
fi

print -- "---- SUMMARY (test hosts: ${#hosts}) ----"
gate=PASS; bad=()
required=("curl(brew)" "curl(system)" "wget(brew)" node bun deno go "python(brew)" "python(system)" "ruby(brew)" "git(brew)" "git(apt)" pnpm "pnpm(native-store)" "openssl(system store)" "openssl(brew store)")
for k in $required; do
  t=${T[$k]:-0}; r=${R[$k]:-0}; e=${E[$k]:-0}; p=${P[$k]-MISSING}
  [[ $k == openssl* ]] && p=n/a
  [[ $k == "pnpm(native-store)" ]] && want=1 || want=${#hosts}
  print -- "SUMMARY\t$k\tTRUSTED=$t\tREJECTED=$r\tERROR=$e\tPOSITIVE=$p\tROWS=$(( t + r + e ))/$want"
  ok=1
  (( t + r + e == want )) || ok=0
  [[ $p == TRUSTED || $p == n/a ]] || ok=0
  (( e > 0 )) && ok=0
  (( t > 0 )) && [[ " ${EXPECT_TRUSTED:-} " != *" $k "* ]] && ok=0
  (( ok )) || { gate=FAIL; bad+=($k); }
done
print -- "GATE: $gate ${bad:+(${(j:, :)bad})}"
```

gocheck/main.go:

```go
package main

import (
	"fmt"
	"net/http"
	"os"
	"runtime"
	"strings"
	"time"
)

func main() {
	c := &http.Client{Timeout: 20 * time.Second}
	r, err := c.Get(os.Args[1])
	if err != nil {
		msg := err.Error()
		if strings.Contains(msg, "x509:") || strings.Contains(msg, "certificate") {
			fmt.Printf("REJECTED(%s)\n", msg)
		} else {
			fmt.Printf("ERROR(%s)\n", msg)
		}
		return
	}
	defer r.Body.Close()
	fmt.Printf("TRUSTED(http %d) %s\n", r.StatusCode, runtime.Version())
}
```

gocheck/go.mod:

```
module gocheck

go 1.27
```

### 4-R. 実施記録 (Claude 実施分、2026-10-22)

| 手順 | 時刻 (JST) | 結果 |
| --- | --- | --- |
| 3-2 brew | 04:19 | `ca-certificates` 2026-09-25 -> 2026-10-20、`mise` 2026.10.3 -> 2026.10.17 (dependents の連鎖なし、旧 keg は cleanup 済み)。cask `claude-code` 2.1.231 -> 2.1.304。brew `cert.pem` は 124 件で `emSign ECC Root CA - G3` 0 件 / `AAA Certificate Services` 0 件。`openssl@3` / `openssl@4` の `cert.pem` symlink は維持。cask 実体は Bun v1.4.4、ISRG 2 件 / emSign 0 件 |
| 3-3 mise probe | 04:25 | `SSL_CERT_FILE` / `SSL_CERT_DIR` を brew ストアに限定しても mise は emSign 系ホストに `200 OK` -> 方式無効 (3-3 の訂正) |
| 3-3 mise | 04:27 | `mise upgrade --no-prune go` -> 1.27.3、`mise upgrade --no-prune --minimum-release-age 0s node deno` -> 26.12.1 / 2.9.8。shims の `node -v` / `go version` / `deno --version` と `mise ls` が新版、`installs/{node,deno,go}/latest` は新版を指す。旧版 (26.11.1 / 26.4.0 / 2.9.7 / 1.27.1) は残置。`.mise.toml` は無変更 |
| 3-4 rustup | 04:27 | `rustup self update` -> 1.29.2 |
| 独立再取得の照合 | 04:33 | Homebrew curl (emSign 系ホストを rc=60 で拒否することを確認) で再取得。node: tarball sha256 が SHASUMS256.txt と一致、アーカイブ 4743 ファイルの内容ハッシュがインストール済みと全件一致 (インストール側の `bin/npm` 1 件は mise が置く npm ラッパーで、26.11.1 / 26.4.0 と同一ハッシュ)。go: tarball sha256 が go.dev の index と一致、15657 ファイル全件一致。deno: zip 内 `deno` とインストール済み `bin/deno` の sha256 一致。rustup: `rustup-init.sha256` と `~/.cargo/bin/rustup` の sha256 一致 |
| 4-6 (brew 側) | 04:31 | 主要 outbound 先 14 ホストに brew curl / system curl とも到達 (200 / 301 / 307 / 404、rc=60 なし)。system 側は 3-1 前なので再確認が要る |
| check.sh (3-2 〜 3-4 後、3-1 前) | 04:28-04:35 | `after-step3-20261022-0428.txt`、211 行、陽性対照は全 client TRUSTED。REJECTED 12/12: curl(brew), wget(brew), node 26.12.1, go 1.27.3 (system ストア未修正でも crypto/x509 の遮断で拒否), python(brew), ruby(brew), git(brew), openssl(brew store)。TRUSTED 6/12 (3-1 待ち): curl(system), python(system), git(apt), openssl(system store)。bun 6/12 TRUSTED (既知の未修正)。pnpm: AAA 系 6 件 REJECTED、emSign 系 6 件は無応答で ERROR (3-1 待ち)。deno 2.9.8 は 12/12 を `CertDistrusted` で拒否していたが、エラーが `TypeError: fetch failed` + `cause` の形式に変わっていたため初回は ERROR 判定になった。check.sh の deno 判定を `cause` 込みに修正し (plan の埋め込みも更新)、3 ホストで REJECTED / REJECTED / 陽性 TRUSTED を再確認。`GATE: FAIL (curl(system), bun, deno, python(system), git(apt), pnpm, openssl(system store))` は 3-1 前の期待値 |
| 3-1 apt (自動) | 06:51 | unattended-upgrades が `ca-certificates` 20260601~26.04.1 -> 20260816ubuntu0.26.04.1 を適用 (`/var/log/dpkg.log`)。Jxck の手動実施は不要だった |
| 3-5 ws (Jxck) | 18:07 | `systemctl restart ws` 済み。MainPID 359714 (root) の起動時刻 18:07:04 は `installs/node/latest -> ./26.12.1` の切替 (04:23) より後で、ExecStart は `installs/node/latest/bin/node server.js` なので実体は 26.12.1。`readlink /proc/359714/exe` は root プロセスのため agent からは Permission denied (sudo で確認する場合: `sudo readlink /proc/$(systemctl show -p MainPID --value ws)/exe`) |
| 3-6 certbot (Jxck) | 18:08 | `/etc/systemd/system/snap.certbot.renew.service.d/override.conf` 作成、`daemon-reload` 済み。`systemctl show -p Environment -p DropInPaths snap.certbot.renew.service` で `DropInPaths=.../override.conf`、`Environment=REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt` |
| 3-7 Claude Code (Jxck) | 18:22 | 全セッション再起動。18:28 時点の稼働 `claude` プロセスは pid 369348 (18:22:34 起動) のみで、実体は `versions/2.1.306` (ISRG 2 件 / emSign 0 件)。ディスク側は 18:22 の自動更新で `~/.local/bin/claude -> versions/2.1.308` (ISRG 2 件 / emSign 0 件) |
| 4-1 / 4-2 | 18:23 | system / brew 両ストアで `emSign ECC Root CA - G3` 0 件。`/etc/ssl/certs/14bc7599.0` と `emSign_ECC_Root_CA_-_G3.pem` は無し。`/etc/ca-certificates.conf` 153 行目は `!mozilla/emSign_ECC_Root_CA_-_G3.crt`。版: apt `ca-certificates` 20260816ubuntu0.26.04.1、brew `ca-certificates` 2026-10-20 / `mise` 2026.10.17、cask `claude-code` 2.1.304、node v26.12.1 / go1.27.3 / deno 2.9.8、rustup 1.29.2 |
| 4-4 | 18:28 | mise probe: 置換先 `dv-g3b-emudhra.we-have-a-problem.com` への行は `certificate verify failed (unable to get local issuer certificate)` のみで `200 OK` 無し。certbot httpx probe (`SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt`): `httpx.ConnectError: [SSL: CERTIFICATE_VERIFY_FAILED]`。稼働中 claude は 3-7 の行のとおり。Homebrew cask 側 2.1.304 (ISRG 2 件 / emSign 0 件) は 18:30 に `brew uninstall --cask claude-code` で撤去し、Brewfile からも cask を外した (7 章 TBD-6 を「native に寄せる」で決定、別 commit)。以後 `claude` は `~/.local/bin/claude` のみ |
| 4-5 | 18:25 | h2o / ws / mozaic.fm / vtt.mozaic.fm は全て active。`curl -sI https://jxck.io/` は `HTTP/2 200`。`journalctl -u ws -n 5` は adm 権限が無く agent からは読めない (未実施。sudo で確認する場合: `sudo journalctl -u ws -n 5`) |
| 4-6 (3-1 後) | 18:28 | 主要 outbound 先 14 ホストに brew curl / system curl とも到達 (200 / 301 / 307 / 404、rc=60 なし)。削除 4 ルートの影響は無し |
| check.sh (3-1 後、1 回目) | 18:31 | `after-step3-1-20261022-1831.txt`、215 行。必須 16 client のうち 15 が TRUSTED 0 / ERROR 0 (REJECTED 12/12、`pnpm(native-store)` 1/1)。bun 1.4.2 は emSign 系 6 件 TRUSTED (`EXPECT_TRUSTED=bun` で許容) / AAA 系 6 件 REJECTED。go 1.27.3 は 11 件 REJECTED、`ev-g3c-emudhra` 1 件だけ `read: connection reset by peer` で ERROR となり `GATE: FAIL (go)`。証明書と無関係な経路エラー (fail-closed) なので、同ホストを単発で再 probe したうえで全体を再実行した |
| check.sh (3-1 後、再実行) | 18:38-18:42 | 単発の go probe (`ev-g3c-emudhra`) は 2 回とも `x509: certificate signed by unknown authority` で REJECTED。全体再実行 `after-step3-1-rerun-20261022-1838.txt` (213 行) は必須 16 client 全てで ERROR 0、陽性対照 TRUSTED、ROWS 12/12 (`pnpm(native-store)` 1/1)。bun のみ emSign 系 6 件 TRUSTED (許容)。**`GATE: PASS`** を最終結果とする |
| 7 章 trigger の現状 | 18:28 | bun: `mise ls-remote bun` の最新 stable は 1.4.3 (修正版 1.4.4 は未リリース)。pnpm 12.10.1 の同梱束は `emSign ECC Root CA - G3` 2 件のまま。certbot snap の certifi は 2026.7.22 で emSign 3 件 (drop-in は継続) |

### 5. ロールバック

- apt: パッケージを戻すと emSign の再信頼になり、翌朝の unattended-upgrades で再適用される。削除 4 ルートが原因の障害が出た場合は、必要なルート 1 件だけを `/usr/local/share/ca-certificates/<name>.crt` に置いて `sudo update-ca-certificates` する。Homebrew 側にも必要なら `brew postinstall ca-certificates` で再結合する
- brew: `brew upgrade` は既定で旧 keg をその場で cleanup するため戻し先は無い。`cert.pem` は自動生成なので壊れた場合は `brew postinstall ca-certificates` で再生成
- mise: `--no-prune` により旧版 (node 26.11.1 / deno 2.9.7 / go 1.27.1) のディレクトリが残る。戻すときは `mise uninstall node@26.12.1` で `installs/node/latest` が 26.11.1 に戻ることを確認してから ws を restart する (`.mise.toml` は触らない。`mise use` は `.mise.toml` を書き換えうるので使わない)
- rustup: 戻し手段は無いが、ルート更新のみで挙動差は無い
- certbot drop-in: `sudo systemctl revert snap.certbot.renew.service`
- claude-code cask: 戻し不要 (shadow されており実行経路に無い)

### 6. リポジトリへの変更

- この plan ファイル (`.agents/plan/`)
- `README.md` に `## TODO` セクションを新設し、本 plan へのリンクを置く
- 実装完了後に同名 `.html` の report を追加して commit する (planning skill の規約)。残作業 (7 章) は README の TODO で追跡する
- `bin/`, `zsh/`, `.mise.toml`, `Brewfile`, `~/develop/jxck.io` は変更しない (check.sh は plan 内に埋め込み、scratchpad で実行)

### 7. 残リスクとフォローアップ (本 plan の範囲外)

| 項目 | trigger | 完了判定 | owner |
| --- | --- | --- | --- |
| Bun stable の修正版 (1.4.4 以降) | `update.sh` の `mise upgrade` で上がる (`mise ls-remote bun` で確認) | check.sh v2 で bun の TRUSTED = 0、mozaic.fm / vtt.mozaic.fm を再起動 | Jxck |
| pnpm の同梱ルート束 (emSign 入り、ストアが空のときの fallback) | pnpm 側の修正版 (12.14.0 時点で未修正) | `strings $(mise where pnpm)/pnpm | grep -c 'emSign ECC Root CA - G3'` が 0 | Jxck |
| certbot drop-in の撤去 | snap の `certifi/cacert.pem` に emSign が無い | `systemctl revert` 後に `systemctl show -p Environment` に両変数が無い | Jxck |
| Claude Code の二重インストール整理 (TBD-6) | ユーザー判断 | **完了 (2026-10-22 18:30)**: native に寄せた。`brew uninstall --cask claude-code` と Brewfile からの `cask "claude-code"` 削除 (別 commit)。native の導入は既存の `install/install-claude.sh` (setup.sh から呼ばれる) | Jxck |
| 長時間稼働の Claude Code セッション | 自動更新はディスク上の版しか変えないため、セキュリティ修正を含む更新のたびにセッションの再起動が要る | 4-4 の稼働中プロセス確認 | Jxck |
| h2o 同梱 `ca-bundle.crt` | https upstream を proxy する構成にするとき | `proxy.ssl.cafile` でシステムストアを指す | Jxck |
| Mac 側 | 依頼は「このサーバ」なので対象外 | `/etc/ssl/cert.pem` (内蔵 curl / git / python3), Homebrew (cask 版 Claude Code の追従確認を含む), mise, Claude Code セッションに同じ対策 | Jxck |
| planning skill の代役記述 | `deep-reasoner` が存在しない環境での代替を skill に書く | agent-maintainer skill の範囲で別途 | Jxck |

- snapd / fwupd 等システムデーモンの TLS は署名検証が別にあるため対象外とした

### 8. 決定済み (旧 TBD 1-5、round 1 の Answer で確定、round 2 で承認)

1. Homebrew は `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade ca-certificates mise` と `brew upgrade --cask claude-code` に限定。python@3.14 は外す。`update.sh` は検証完了後
2. certbot は drop-in (案 A)。probe は読み取りのみ (陰性対照つき)、acceptance と撤去条件を明記、リポジトリでは管理しない
3. node / deno は `--no-prune --minimum-release-age 0s` で即時適用。pin しない。取得物は Homebrew curl による独立再取得と内容ハッシュで照合する (当初の `SSL_CERT_FILE` 方式は実施時に無効と判明)
4. `DENO_TLS_CA_STORE=system` は入れない
5. check.sh v2 は plan に埋め込み自己完結。`bin/` には置かない


## TBD

6. **Claude Code の二重インストール** (ユーザー判断): native 版 (`~/.local/bin/claude`, 自動更新で 2.1.306) と Homebrew cask (Linux では Brewfile にも `update.sh` にも管理されない手動インストール。2.1.231 -> 2.1.304) が共存している。本 plan では cask を upgrade するに留める。レビュアーの推奨は「このホストでは native に寄せ `brew uninstall --cask claude-code` で外す (Brewfile は mac 用なので変更不要)」。Claude も同意見だが、削除はユーザーの決定を待つ

## Review by Claude Opus (general-purpose, Codex 代役) (2026-10-22)

レビュー方法: プランの事実主張を, このホスト上の読み取り専用の操作で裏取りした (`dpkg-query`, `apt-get -s`, 修正版 .deb の `apt-get download` と scratchpad への展開, `brew outdated` / `brew info` / `brew upgrade --dry-run`, `mise upgrade --dry-run` / `mise ls-remote` (`MISE_CACHE_DIR` を scratchpad に隔離), `strace`, バイナリ内の文字列検索, テストホストへの GET, `check.sh --quick`). 対策そのものは何も実行していない. 裏取り中に `brew cat` が Homebrew の developer mode を自動で on にしたため, `brew developer off` で元に戻した (minor 18)

### 総評

- **approve 不可 (request changes)**. blocker 2 / major 4 / minor 13
- apt (`ca-certificates`) と Homebrew formula に関する主張は正確 (.deb の changelog と実ファイル差分, formula HEAD, brew dry-run の結果と一致)
- 一方で "どのクライアントがどのストアを見るか" の主張に誤りが複数ある. 最も機密性の高い outbound クライアント (Claude Code) が対象から漏れている. acceptance は fail-open で, 保存済みのベースライン自体がその空振りを含んでいる
- 3-1 -> 3-2 -> 3-3 の順序は妥当 (mise の汎用 HTTP クライアントはシステムと Homebrew の両方のストアを読むため, 3-1 と 3-2 の後に 3-3 を行う必要がある). 必要な修正は主に, 対象の追加, mise 手順の書き直し, acceptance の作り直しの 3 点

### Blocker

1. **acceptance (check.sh) が空振りと誤判定の両方を起こす**
  - fail-open: curl は `rc != 0` を, node / deno / bun / go / python / ruby は任意の例外を REJECTED と判定する. DNS 失敗, タイムアウト, テストホストの停止 (第三者の運営で恒久性の保証は無い), スクリプトのバグでも "全 REJECTED = 合格" になる
  - 実例: `baseline-20261022-0224.txt` では bun が 12 ホスト全てで `REJECTED(ERR_INVALID_URL)` になっており, 証明書と無関係の失敗が REJECTED として記録されている. 現行の check.sh を `--quick` で再実行すると, bun 1.4.2 は emSign 系で `TRUSTED(http 200)` になる. つまり保存済みベースラインは現行スクリプトの出力ではなく, 2 章の表の bun / git の値を裏付ける保存結果が存在しない
  - git は逆方向に壊れている: Homebrew git 2.56.0 の TLS 失敗の文言は `SSL certificate OpenSSL verify result: unable to get local issuer certificate (20)` で, `SSL certificate problem` を含まない. `--quick` で AAA ホストが `TRUSTED(fatal: unable to access ...)` と出ることを実測した. このままでは修正後も git は 12/12 TRUSTED のままで gate が永久に通らず, 通すために判定を緩める誘惑が生じる. 表にある apt 版 git (`/usr/bin/git`, gnutls, 文言は `SSL certificate verification failed: certificate signer not trusted`) は検査されていない
  - go は `cd gocheck` が相対パスなので, check.sh のディレクトリ以外から実行すると go のエラー行だけが出て判定語を含まない. "TRUSTED が 0 行" で数えると合格扱いになる
  - プラン埋め込み版は scratchpad 版にある版ラベル (`node($(node -v))` 等) が落ちている. mise の PATH は go / deno が版付きディレクトリ (`installs/go/1.27.1/bin` 等) なので, hook-env が走らない非対話シェルや agent から実行すると旧バイナリを検査しうる
  - 修正案:
    - 判定を 3 値にする. 成功は TRUSTED. クライアントごとの証明書エラー (curl `rc=60`, node / bun の `UNABLE_TO_GET_ISSUER_CERT_LOCALLY` 等の `CERT_` / `UNABLE_` 系, deno の `invalid peer certificate` / `UnknownIssuer`, go の `x509:`, python の `CERTIFICATE_VERIFY_FAILED`, ruby の `OpenSSL::SSL::SSLError` かつ verify 系メッセージ, git の `SSL certificate` または `certificate verification failed`) は REJECTED. それ以外は ERROR とし, ERROR が 1 件でもあれば gate 不成立
    - 同じ実行の中に陽性対照を入れる. 各クライアントで既知の正常ホスト (例: `https://valid-isrgrootx1.letsencrypt.org/`) が TRUSTED になることを必須にする
    - 合格条件を件数で定義する: "(クライアント数) x 12 行が全て REJECTED, ERROR 0 件, 陽性対照が全て TRUSTED"
    - 各行に版を出し, 2 の期待版と照合する
    - テストホストに依存しない検査を併用する. アドバイザリの `chains.zip` を使い, OpenSSL 系のストア (`/etc/ssl/certs/ca-certificates.crt`, Homebrew の `cert.pem`) は `openssl verify -CAfile <store> -untrusted <chain>` でオフライン判定する
    - `gocheck/main.go` (15 行) と `isrg-only.pem` はセッション限りの scratchpad にしか無いので, plan に埋め込む
    - 変更前に修正版スクリプトでベースラインを取り直し, plan か report に保存する
2. **Claude Code (Homebrew cask `claude-code` 2.1.231) が対象から漏れている**
  - 実体は Bun 製の single-file executable (バイナリ内に `Bun v1.4.0`). 埋め込み PEM を抽出すると 121 件で, `emSign ECC Root CA - G3` を含む (Bun 1.4.2 の `getCACertificates("bundled")` も 121 件)
  - Anthropic の認証情報と, リポジトリの内容を含むプロンプトを api.anthropic.com へ送るクライアントである. TBD-2 で certbot に適用した "token を送る経路" という理由がそのまま当てはまる. tldr と 7 章の "Bun の実害は `bun install` に限られる" は誤り
  - cask の最新 2.1.304 の Linux バイナリを scratchpad に取得し, 実行せず静的に調べた. 内蔵 Bun は `v1.4.4` (公開 stable は 1.4.3 まで). ルートは DER で保持され `ISRG Root X1` / `DigiCert Global Root G2` の文字列はある一方, `eMudhra` / `emSign` は 0 件. 修正済みである可能性が高い (実行時の probe は未実施)
  - README の "Cask の通常更新は各アプリの更新機能に任せる" は, 少なくともこの cask では機能していない (インストール済み 2.1.231, 最新 2.1.304)
  - 修正案: 3-2 に `brew upgrade --cask claude-code` を追加する. acceptance に "インストール済みバイナリの埋め込みルートに eMudhra / emSign が無いこと" (静的確認) を入れ, 実行時確認ができない点は残リスクとして明記する. Claude Code のセッション内から更新した場合, セッションを再起動するまで旧バイナリで動き続ける点も手順に書く

### Major

3. **mise の信頼ストアの記述が誤りで, mise 本体の更新が手順に無い**
  - 表は "rustls-native-certs (システムストア), apt 更新で解決" としているが, Homebrew 版 mise 2026.10.3 は openssl@4 (`libssl.so.4`) にリンクしており, strace では `/etc/ssl/certs/ca-certificates.crt` と `$(brew --prefix)/etc/openssl@4/cert.pem` の両方を開いている. apt だけでは直らず, Homebrew の `ca-certificates` 更新も必要
  - さらに built-in の npm backend (`npm.shell_out = false`) は rustls-platform-verifier と同梱ルートを使う. `SSL_CERT_FILE` を ISRG のみにして `NPM_CONFIG_REGISTRY` をテストホストに向けると, AAA 側は即座に `invalid peer certificate: UnknownIssuer` になるが, emSign 側は UnknownIssuer にならず 20s でタイムアウトした (TLS は通った可能性が高い). mise v2026.10.17 の release notes に "The built-in npm backend no longer trusts the eight eMudhra intermediate CA certificates ... (`webpki-root-certs` 1.0.10, `rustls-webpki` 0.103.16)" とある. `.mise.toml` には `npm:` のツールが 2 件ある
  - mise 2026.10.17 は `brew outdated` に出ているが, `brew upgrade --dry-run ca-certificates python@3.14` では "dependents 21 件" の側に入るので, `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1` では上がらない. `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade --dry-run mise` で追従するのは ca-certificates のみ
  - 修正案: 3-2 を `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade ca-certificates mise` にする (python@3.14 は minor 7 参照). acceptance に mise の probe を加える. 例: `MISE_CACHE_DIR=<一時 dir> MISE_URL_REPLACEMENTS='{"https://mise-versions.jdx.dev":"https://dv-g3b-emudhra.we-have-a-problem.com"}' MISE_VERBOSE=1 mise ls-remote deno` が TLS エラーになること (現状はこれで `200 OK` になることを確認済み)
4. **node / deno が上がらない原因の誤診 (版一覧の遅延ではなく `minimum_release_age`)**
  - `mise upgrade --dry-run node` の出力は `newer node release 26.12.1 (released 2026-10-21, eligible 2026-10-22 09:00 JST) ignored by minimum_release_age (24h)`. deno も `newer deno release 2.9.8 (released 2026-10-22, eligible 2026-10-23 00:28 JST) ignored by minimum_release_age (24h)`. `mise settings get minimum_release_age` は未設定なので, mise の既定値として効いている
  - `mise ls-remote` も同じフィルタを通るため, 一覧に 26.12.1 / 2.9.8 が "無い" ように見えていた. `--minimum-release-age 0s` (または `MISE_MINIMUM_RELEASE_AGE=0s`) を付けると ls-remote に両方が出て, `mise upgrade --dry-run node --minimum-release-age 0s` は `Would install node@26.12.1` になる
  - `MISE_USE_VERSIONS_HOST=0` で deno 2.9.8 が出るのは, 取得元によってリリース時刻の記録が違うための偶然である. 同じ設定で node は逆に `eligible 2026-10-23 08:59 JST` に後退する. 回避策として採用すべきではない
  - 修正案: 3-3 を "いつ, どの版を, どのフラグで" 入れるかで書き直す (TBD-3 の推奨参照). `mise cache clear` は不要
5. **mise のロールバックの記述が成り立たない**
  - `upgrade.auto_prune = true`, `upgrade.prune_after = 24h` のため, `mise upgrade` は旧版を 24h 後に自動削除する予約を入れる (dry-run の出力に `Would schedule node@26.11.1 for pruning after 24h`). "`mise prune` するまで残る" は誤り. また `update.sh` は `mise prune -y` を実行する
  - `installs/node/latest` は "インストール済みの最高版" への symlink である (現状 `latest -> ./26.11.1`). `mise use node@26.11.1` はこれを変えないので ws.service のロールバックにならない. さらに `MISE_GLOBAL_CONFIG_FILE=$DOTFILES/.mise.toml` の環境では `mise use` が `.mise.toml` を書き換えうる (6 章の "`.mise.toml` は変更しない" と矛盾する)
  - 修正案: `mise upgrade --no-prune ...` を使い, 旧版の削除は検証完了後に手動で行う. ws.service の戻し方は "新版を `mise uninstall` して `latest` を旧版に戻す" か "ExecStart を版指定のパスに一時変更する" と書く
6. **certbot (案 A) に gate, 適用範囲, 撤去条件が無い**
  - コード上の前提は正しいことを確認した. requests 2.34.2 は `sessions.py` で `REQUESTS_CA_BUNDLE` を読み, httpx 0.28.1 は `trust_env` のとき `_config.py` で `SSL_CERT_FILE` を読む. snap は classic で, `snap.yaml` の `environment:` はこれらを上書きしない. 両 snap の certifi 2026.7.22 の `cacert.pem` に `emSign ECC Root CA - G3` があることも確認した
  - しかし 4 章の acceptance に certbot の項目が無い. また drop-in は `snap.certbot.renew.service` にしか効かず, 手動の `sudo certbot certonly ...` 等は certifi のままになる
  - 撤去条件が無い. "certbot snap の certifi が 2026.10.19 以上になったら `systemctl revert` する" という条件と, 確認方法 (`ls /snap/certbot/current/lib/python3.12/site-packages/ | grep certifi`) を書く
  - システム状態の変更がどのリポジトリにも記録されない. deploy hook は jxck.io の `.systemd/` で管理して `slink.sh` で配備しているので, drop-in も同じ場所で管理するのが一貫する
  - 事前 probe の `certbot renew --dry-run` は Cloudflare に TXT を書く (外部への書き込み). 読み取りだけで env の伝搬を確認できる代替がある. requests の経路は `sudo REQUESTS_CA_BUNDLE=/nonexistent certbot show_account` が失敗し, 正しいパスでは成功することを見る. httpx の経路は certbot snap の python に `PYTHONPATH=/snap/certbot-dns-cloudflare/current/lib/python3.12/site-packages` を足し, `httpx.get("https://dv-g3b-emudhra.we-have-a-problem.com/")` が `SSL_CERT_FILE` 有りで失敗することを見る. どちらも `snap run` を経由するので, systemd 経路と同じ env 伝搬を検証できる

### Minor

7. **pip の根拠が誤りで, python@3.14 の upgrade は本件に不要**: pip 26.2.1 は truststore が常時有効 (`cmdoptions.py` の "always on since 24.2") で, Linux では OpenSSL の既定パス (= Homebrew の `cert.pem`) を使う (pip 同梱 truststore の `_openssl.py` で確認). 同梱 certifi を使うのは `--use-deprecated=legacy-certs` のときだけ. 一方 python@3.14 3.14.8_3 は `depends_on "openssl@4"` で, 現在の `ssl.OPENSSL_VERSION` (3.6.5) から OpenSSL 4 系にリンク先が変わる. インシデント対応と無関係な挙動変更で, 旧 keg は自動 cleanup で消えるため戻せない. 本 plan からは外すことを推奨する (TBD-1)
8. **tldr の "`AAA Certificate Services` 経由は既に全クライアントで遮断済み" は誤り**: 2 章の表とベースライン, `--quick` の実測のいずれでも deno 2.9.7 は AAA 系を TRUSTED にする
9. **rustup の根拠が誤り**: rustup 1.29.1 のバイナリにはルート名の文字列が無く, strace では `/etc/ssl/certs/<hash>.0` を読んでいる (rustls-platform-verifier / rustls-native-certs). apt で直る. `rustup self update` は無害なので残してよいが理由を書き換える. cargo は `/usr/lib/ssl/cert.pem` (-> `/etc/ssl/certs/ca-certificates.crt`) を読むことを strace で確認した (プランどおり)
10. **表と acceptance から漏れているクライアント (apt / brew で直るが未検査)**: pnpm 12.10.1 (rustls を使う. `SSL_CERT_FILE` を ISRG のみにすると registry.npmjs.org も拒否したのでネイティブストア参照と確認), apt 版 git (gnutls), `op` (1password-cli cask, Go), Homebrew の wget (`+ssl/openssl`), `bin/` の ruby スクリプト (ghbin, upload 等は Homebrew ruby). 少なくとも pnpm と apt 版 git は check.sh に入れる
11. **acceptance 1 がハッシュディレクトリを見ていない**: rustup / mise / pnpm は `/etc/ssl/certs/<hash>.0` も読む. `/etc/ssl/certs/14bc7599.0` と `emSign_ECC_Root_CA_-_G3.pem` が消えていることも確認項目に入れる. なお現行の grep は自己署名ルートの subject と issuer の 2 行に当たり, 現状値は 2 (空振りはしない)
12. **acceptance 5 (副作用) の確認先が github.com だけ**: 削除される 4 ルートは .deb の changelog と `/usr/share/ca-certificates/mozilla` の差分で確認した. 主要な outbound 先 20 件 (acme-v02.api.letsencrypt.org, api.cloudflare.com, registry.npmjs.org, proxy.golang.org, pypi.org, github.com, ghcr.io, formulae.brew.sh, nodejs.org, dl.deno.land, static.rust-lang.org, index.crates.io, rubygems.org, api.anthropic.com 等) の最上位 issuer は ISRG / GlobalSign / USERTrust / DigiCert で, 削除 4 ルートへの依存は無い. この一覧で確認する方が実効的
13. **Bun の判定に `tls.getCACertificates("system")` を使わないこと**: Bun 1.4.2 の `"system"` は OS ストア (121 件. `SSL_CERT_FILE` は無視) を返すが, 既定の検証に使われるのは `"bundled"` (121 件, emSign を含む) だけ. `--use-system-ca` を付けると `"default"` が 242 件 (和集合) になる. apt 後に `"system"` から emSign が消えても Bun が直った根拠にはならない. report で誤用しないよう明記する
14. **unattended-upgrades の時刻は不定ではない**: `apt-daily-upgrade.timer` の次回は 2026-10-22 06:50 JST で, 修正版は既に resolute-security の candidate. 手動の実施がこの前後に重なると dpkg lock を取り合う. 06:50 以降に実施する場合はベースラインの前提も変わる
15. **apt のロールバックは emSign の再信頼を伴い, 翌朝には unattended-upgrades で再適用される**: 削除 4 ルートが原因の障害なら, パッケージを戻すより, 必要なルート 1 件だけを `/usr/local/share/ca-certificates/` に置く方が目的に合う (12 の確認から必要になる可能性は低い)
16. **残作業に owner と期限が無い**: node 26.12.1, deno 2.9.8 (eligible 時刻待ち), Bun stable (1.4.4 以降), certbot drop-in の撤去, Claude Code. それぞれ "誰が, いつ (日時かトリガ), 何を見て完了とするか" を Fixed Plan の TODO に書く. 残作業がある状態で HTML report を作るかどうかも決めておく
17. **`/etc/ca-certificates.conf` は conffile ではない**: `dpkg-query -W -f='${Conffiles}' ca-certificates` は空. debconf (`ca-certificates/enable_crts`, `trust_new_crts: yes`) と postinst が管理する. prompt が出ないという結論は同じだが理由が誤り
18. **probe 時の注意**: formula を確かめるために `brew cat` を使うと developer mode が自動で on になり, `brew update` が main の最新 commit を追うようになる. formula の確認は `brew info --json=v2` か GitHub 上の raw を読む
19. **レビュー体制の記述**: planning skill は代役を `deep-reasoner` とし, 見出しを `## Review by Claude Opus (deep-reasoner) (日付)` と定めている. 今回は general-purpose を使っているので, skill を更新するか, 7 章に逸脱の理由を書く

### TBD への推奨

1. **Homebrew の upgrade 範囲**: `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade ca-certificates mise` と `brew upgrade --cask claude-code` を推奨する. python@3.14 は外す (minor 7). 通常の `brew upgrade` の dependents 21 件は `openssl@3 3.6.5 -> 3.5.9` のような版の後退表示や, ffmpeg, systemd, tmux 3.8 等を含み監査範囲が広がるので混ぜない. `update.sh` は `mise prune -y` と `brew cleanup` で旧版を消すので, 検証が完了するまで回さない
2. **certbot snap**: 案 A に同意する. 条件は 4 つ. (a) 事前 probe を読み取りのみの方法にする (major 6), (b) acceptance に certbot の項目を加える, (c) 撤去条件を書く, (d) drop-in を jxck.io の `.systemd/` で管理する. 手動で certbot を実行する場合は, 撤去までの間 `sudo REQUESTS_CA_BUNDLE=... SSL_CERT_FILE=... certbot ...` で運用する
3. **node の版**: pin しないことに同意する. ただし前提を "一覧の遅延" から "`minimum_release_age` の 24h" に改める. 推奨は既定の待機を尊重すること. eligible になった後 (mise の表示では node は 2026-10-22 09:00 JST, deno は 2026-10-23 00:28 JST) に `mise upgrade --no-prune node deno` を実行し, 直前に dry-run で対象版を確認する. go 1.27.3 は今すぐ対象になる. 理由: 24h の待機はリリース直後の改ざん版を避けるための既定であり, ws は外向き TLS を行わず, node / deno の CLI 利用は手動なので待つコストが小さい. 当日中に閉じる必要がある場合は, node / deno に限って `--minimum-release-age 0s` を明示的に付ける (設定ファイルを変えない一回限りの上書き). `MISE_USE_VERSIONS_HOST=0` は使わない
4. **Deno の恒久設定**: 入れないことに同意する. 理由は "2.9.8 で同梱ストアが直る" で足りる. "Mac との差分が増える" は理由として弱い (Mac の `system` は Keychain で, OS 側でブロック済み). TBD-3 で deno を待つ場合でも, 1 日弱の対話利用のためにシェル設定を変える価値は低い
5. **check.sh の置き場**: `bin/` に置かないことに同意する. ただし plan への埋め込みは, blocker 1 を修正したスクリプト, `gocheck/main.go`, 陽性対照のホストまで含めて自己完結にする. 修正前と修正後の実行結果は report に残す


## Answer by Claude (2026-10-22)

全 finding について、事実主張はこのホストで再検証した上で回答する。結論: blocker 2 件は受け入れ (2 は実体の訂正付き)、major 4 件は全て受け入れ、minor は 19 を除き受け入れ (19 は部分)。TBD の決定は末尾。round 2 で approve が出れば、本文をこの回答どおりに清書して Fixed 化する。

### Blocker

1. **受け入れ**。check.sh を v2 に作り直した (scratchpad `check2/check.sh`, `check2/gocheck/`)。変更点:
  - 判定を 3 値化 (TRUSTED / REJECTED / ERROR)。REJECTED はクライアントごとの証明書エラーに限定 (curl `rc=60`, wget `rc=5`, node / bun の `CERT_* / UNABLE_TO_*`, deno の `certificate|UnknownIssuer`, go の `x509:`, python の `SSLCertVerificationError`, ruby の `certificate verify failed`, git の `SSL certificate` / `certificate verification failed`, pnpm の `invalid peer certificate`)。それ以外は ERROR
  - 陽性対照 `valid-isrgrootx1.letsencrypt.org` を同一実行に含め、全クライアントで TRUSTED を必須にする
  - 各行に版を出す。mise 管理のツールは `~/.local/share/mise/shims/<tool>` を明示パスで呼び、hook-env が走らないシェルでも現在の版を検査する
  - go は `${0:A:h}/gocheck` の絶対パス。`gocheck/main.go` と `go.mod` は plan に埋め込む
  - git は実測した文言で判定する (brew git: `SSL certificate OpenSSL verify result`, apt git: `SSL certificate verification failed` -> REJECTED、`is this a git repository` -> TRUSTED)。apt 版 git, pnpm, wget を追加 (minor 10)
  - chains.zip (`--chains DIR`) で system / brew の両ストアに対して `openssl verify -CAfile <store> -untrusted <chain> <chain>` を行うオフライン判定を追加。テストホストに依存しない
  - 末尾に `SUMMARY` (client ごとの TRUSTED / REJECTED / ERROR 件数と陽性対照) と `GATE: PASS|FAIL` を出す。合格条件は「全 client で ERROR = 0、陽性対照 = TRUSTED、`EXPECT_TRUSTED` に列挙した未修正 client 以外は TRUSTED = 0」
  - ベースラインは v2 で取り直し (`check2/baseline-v2-*.txt`)、修正前後の結果を report に残す。v1 の保存結果は bun の `ERR_INVALID_URL` を含むため採用しない (2 章の bun / git の値は v1 実行後の手動再実行で得たもので、保存結果が無いという指摘はそのとおり)
2. **部分的に受け入れ、実体を訂正**。実測:
  - `which -a claude` は `~/.local/bin/claude` (-> `~/.local/share/claude/versions/2.1.306`, native installer, バイナリ内 `Bun v1.4.4`) が先で、Homebrew cask (`$(brew --prefix)/bin/claude`, 2.1.231, `Bun v1.4.0`) は PATH 上で shadow されている。このセッションの親プロセスも native 版 2.1.306
  - 2.1.306 の静的検査: `ISRG Root X1` 2 件 (陽性対照) に対し `emSign ECC Root CA - G3` 0 件。静的には修正済みと判断する
  - cask 2.1.231 は `ISRG Root X1` も 0 件で、この binary では文字列検索自体が無効 (レビュアーの PEM 抽出結果「121 件、emSign 含む」を採用する)
  - 対応: 3-2 に `brew upgrade --cask claude-code` (2.1.231 -> 2.1.304) を追加する。acceptance に両 binary の静的確認 (陽性対照つき) を入れ、実行時 probe ができない点は残リスクに書く。native 版と cask 版の二重インストールをどちらに寄せるかは本 plan の範囲外とし、TBD-6 として残す
  - tldr と 7 章の「Bun の実害は `bun install` に限られる」は「Bun 1.4.2 の CLI 利用に限られる。Claude Code は Bun 1.4.4 ベースの native 版が稼働しており別途確認済み」に改める。README の「Cask の通常更新は各アプリの更新機能に任せる」が claude-code で機能していない点はフォローアップに書く

### Major

3. **受け入れ**。`ldd $(brew --prefix)/bin/mise` で `libssl.so.4` (openssl@4) を確認。`etc/openssl@4/cert.pem` も `etc/ca-certificates/cert.pem` への symlink。mise v2026.10.17 の release notes に「The built-in npm backend no longer trusts the eight eMudhra intermediate CA certificates」「`webpki-root-certs` 1.0.10, `rustls-webpki` 0.103.16」を確認。`npm.shell_out` は false (既定) で、`.mise.toml` の `npm:` ツール 2 件が該当する。3-2 を `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade ca-certificates mise` に変更 (dry-run で対象 2 件のみを確認)。表の mise 行は「openssl@4 経由で system と brew の両ストアを読む。npm backend は同梱ルート」に訂正し、acceptance に `MISE_URL_REPLACEMENTS` による probe を加える
4. **受け入れ**。`mise upgrade --dry-run node deno go` で `ignored by minimum_release_age (24h)` (node: eligible 2026-10-22 09:00 JST, deno: 2026-10-23 00:28 JST) を再現し、`--minimum-release-age 0s` で `Would install node@26.12.1 / deno@2.9.8` を確認。`MISE_USE_VERSIONS_HOST=0` と `mise cache clear` は撤回する。3-3 は TBD-3 の決定に従って書き直す
5. **受け入れ**。`upgrade.auto_prune = true`, `upgrade.prune_after = 24h`、dry-run の `Would schedule node@26.11.1 for pruning after 24h` を確認。`mise upgrade` には `--no-prune` を付け、旧版の削除は検証完了後に手動で行う。ロールバックは「ws.service に drop-in で `ExecStart` を `installs/node/26.11.1/bin/node` に一時変更」を正とし、`mise use` は使わない (`.mise.toml` を書き換えうるため)。`update.sh` (`mise prune -y`, `brew cleanup`) は検証完了まで回さない
6. **条件 a / b / c を受け入れ、d は不採用**。
  - a: 事前 probe を読み取りのみに変える。requests 経路は `sudo REQUESTS_CA_BUNDLE=/nonexistent certbot show_account` の失敗と正しいパスでの成功 (`show_account` サブコマンドの存在は `certbot --help all` で確認)。httpx 経路は certbot snap の python に `PYTHONPATH=/snap/certbot-dns-cloudflare/current/lib/python3.12/site-packages` を足し、`SSL_CERT_FILE` 有りで emSign 系テストホストが拒否されることを見る。`certbot renew --dry-run` は使わない
  - b: acceptance に certbot の項目を追加する
  - c: 撤去条件「`/snap/certbot/current/lib/python3.*/site-packages/` の certifi が 2026.10.19 以上になったら `sudo systemctl revert snap.certbot.renew.service`」を書く。手動実行時は `sudo REQUESTS_CA_BUNDLE=... SSL_CERT_FILE=... certbot ...` とする
  - d: 不採用。実測では `~/develop/jxck.io/.systemd/` にあるのは h2o / ws / webauthn-demo の unit と slink.sh だけで、certbot 関連は無い。drop-in は撤去条件付きの一時措置であり、そのために別リポジトリへ commit するのは本依頼の範囲を超える。状態変更は本 plan (撤去条件と確認コマンド込み) と report に記録する。恒久化するなら別途判断する

### Minor

7. **受け入れ**。pip の `cmdoptions.py` に `"truststore",  # always on since 24.2` を確認。python@3.14 3.14.8_3 の `dependencies` に `openssl@4` を確認。python@3.14 は plan から外す。pip は Homebrew の `cert.pem` 更新で解決
8. **受け入れ**。tldr を「AAA 系は deno 以外で遮断済み」に修正
9. **受け入れ**。strace で rustup が `/etc/ssl/certs/<hash>.0` を読むことを確認。`rustup self update` は「無害な追従 (任意)」に格下げして残す
10. **受け入れ**。pnpm / apt git / wget を check.sh v2 に追加 (pnpm の文言は較正済み: `ERR_PNPM_RESOLVING_NPM_RESOLVER_DECODE_ERROR` = TRUSTED、`invalid peer certificate: UnknownIssuer` = REJECTED、404 = TRUSTED)。op (Go, system store) と bin/ の ruby スクリプト (brew ruby) は表に追記し、apt / brew で解決する旨を書く
11. **受け入れ**。`/etc/ssl/certs/14bc7599.0` と `emSign_ECC_Root_CA_-_G3.pem` の消失を acceptance に加える
12. **受け入れ**。副作用確認は主要 outbound 先の一覧 (acme-v02.api.letsencrypt.org, api.cloudflare.com, registry.npmjs.org, proxy.golang.org, pypi.org, github.com, ghcr.io, formulae.brew.sh, nodejs.org, dl.deno.land, static.rust-lang.org, index.crates.io, rubygems.org, api.anthropic.com) に brew curl と system curl で到達確認する形に変える
13. **受け入れ**。Bun の `getCACertificates("system")` を修正の根拠に使わない旨を report に注記する
14. **受け入れ**。`apt-daily-upgrade.timer` の次回 2026-10-22 06:50 JST を確認。実施は 06:50 より前に行い、重なった場合は dpkg lock の解放を待つ
15. **受け入れ**。apt のロールバックは「必要なルートだけを `/usr/local/share/ca-certificates/` に置いて `update-ca-certificates`」に変える
16. **受け入れ**。Fixed の TODO に各残作業の trigger と完了判定を書く。HTML report は実装 commit 時点のスナップショットとして作り、未完項目 (Bun stable, certbot drop-in 撤去, Claude Code の二重インストール) は README の TODO で追跡する
17. **受け入れ**。`dpkg-query -W -f='${Conffiles}' ca-certificates` が空であることを確認。文言を「debconf と postinst が管理」に直す
18. 了解。formula の確認は GitHub raw と `brew info --json=v2` で行う
19. **部分的に受け入れ**。7 章に「skill の `deep-reasoner` はこの環境に存在しないため general-purpose + opus を使った」と逸脱理由を明記する。skill 本文の更新は本 plan の範囲外 (agent-maintainer skill の領分) としてフォローアップに書く

### TBD の決定

1. **確定**: `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade ca-certificates mise` と `brew upgrade --cask claude-code`。python@3.14 は外す。`update.sh` は検証完了後に通常運用で回す
2. **確定**: 案 A。条件 a / b / c を採用、d は不採用 (理由は major 6)
3. **確定 (レビュアー推奨と一部異なる)**: node / deno は今回に限り `mise upgrade --no-prune --minimum-release-age 0s node deno` で即時適用する。go は `mise upgrade --no-prune go`。理由: 依頼は「レビュー後に実行」で当日中に閉じる。両方とも本インシデントに対する vendor のセキュリティリリースで、mise は checksum 検証付きで取得する。24h 待機の目的 (直後の撤回リスク回避) より、修正の先送りの方が本件では不利と判断した。設定ファイルは変えない一回限りの上書き
4. **確定**: `DENO_TLS_CA_STORE` は入れない
5. **確定**: plan に check.sh v2 / gocheck / chains.zip の使い方を埋め込み自己完結にする。bin/ には置かない
6. **新規 (ユーザー判断)**: Claude Code は native 版 (`~/.local/bin/claude`, 自動更新) と Homebrew cask (Brewfile 管理、手動更新) の二重インストールになっている。本 plan では cask を upgrade するに留める。どちらに寄せるかは別途


## Review by Claude Opus (general-purpose, Codex 代役) round 2 (2026-10-22)

レビュー方法: `## Answer by Claude` の各回答と書き直し後の本文を突き合わせ, 事実主張を読み取り専用の操作で裏取りした (`dpkg -l`, `apt-cache policy`, `apt-get -s`, 修正版 .deb の postinst 抽出, `brew info --json=v2`, `HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade --dry-run`, `mise upgrade --dry-run` (`MISE_CACHE_DIR` を隔離), `mise settings get`, `ldd`, `strings`, `/proc/<pid>/exe`, `systemctl cat` / `show`, `snap list`, snap 内ソースの grep, 非 root での snap python からの GET, PyPI の certifi wheel の検査, 完了済みの `baseline-v2-20261022-0344.txt` の読解). 対策そのもの, sudo, `certbot show_account`, `certbot renew --dry-run` は実行していない. 1 点報告: pnpm の probe を shim 経由かつ `XDG_DATA_HOME` を scratchpad に向けて実行した際, mise が scratchpad 側の data dir に pnpm 12.14.0 を自動 install した. 実環境の `~/.local/share/mise/installs` は無変更 (mtime で確認). scratchpad 側は除去し (rm は `/tmp/.trash` への移動), 以後の pnpm probe は 12.10.1 のバイナリを直接呼んで取り直した

### 総評

- **approve**. blocker 0 / major 2 / minor 8. major 2 件は Fixed の清書時に本文へ反映すること (どちらも手順と判定の追記で済み, 方針の変更は不要)
- Answer の受け入れ内容は概ね本文に反映されている. 次を再現した: apt (candidate 20260816ubuntu0.26.04.1, 変更 1 件, 消えた cert を postinst が `!` 付きにする), Homebrew (ca-certificates 2026-10-20 / mise 2026.10.17 / cask 2.1.304 の dry-run, formula の除外 SPKI に `emSign ECC Root CA - G3` の SPKI SHA256 が一致), mise (`--no-prune` と `--minimum-release-age` の存在, dry-run の版, `upgrade.auto_prune = true` / `prune_after = 24h`), certbot (classic, snap.yaml が CA 系の env を上書きしない, requests / httpx の env 処理), ベースライン v2 (`GATE: FAIL`, 2 章の要約と一致)
- 反論 2 点に blocker 相当の懸念は残らない. drop-in は撤去を忘れても apt 管理のシステムストアを指すだけで害が無く, `DropInPaths=` は現状空なので `systemctl revert` が他を巻き込むことも無い. `--minimum-release-age 0s` は対象が vendor のセキュリティリリース (node 26.12.1 は nodejs.org の index で `security: true`) で, 3-1 / 3-2 で取得経路を直した後に取るので許容できる (根拠の書き方は minor 7)
- check.sh v2 の 3 値判定と陽性対照は機能している. openssl 行は `-CAfile` を指定しても既定の CApath (`/usr/lib/ssl/certs` = `/etc/ssl/certs`) を併用するので, pnpm / rustup が読むハッシュディレクトリも同時に検査できている. 残る穴は GATE が "証拠の欠落" を検出しないこと (major 2)
- 新たな見落としとして, 稼働中の Claude Code が未修正版で動いている (major 1)

### Major

1. **稼働中の Claude Code は 2.1.306 ではなく 2.1.296 (Bun v1.4.3, emSign あり)** (round 1 の 2 の続き)
  - このレビューの Bash の親プロセス (pid 232138, comm `claude`) の `readlink /proc/232138/exe` は `~/.local/share/claude/versions/2.1.296`. 開始は 02:16:58 で, `~/.local/bin/claude -> 2.1.306` の symlink と 2.1.306 本体の mtime は 02:17. 自動更新はディスク上の版を変えただけで, plan を書いたセッションも同じプロセスと考えられる. Answer の "このセッションの親プロセスも native 版 2.1.306" と, tldr / 2 章の "native 版 (Bun 1.4.4 ベース) が稼働中" は誤り
  - 静的検査 (4-4 と同じ方法): 2.1.288 / 2.1.289 / 2.1.296 は `ISRG Root X1` 2 件, `emSign ECC Root CA - G3` 2 件 (Bun v1.4.3). 2.1.306 は ISRG 2 件 / emSign 0 件 (Bun v1.4.4). つまり 2.1.296 は文字列検索が有効な状態で emSign を含む
  - round 1 で求めた "セッション内から更新した場合, 再起動まで旧バイナリで動き続ける点を手順に書く" が本文に入っていない. また 4-4 は `versions/*` 全件を回すので, 未使用の旧版 3 件が emSignG3=2 を出して合否が読めない. 一方で実際に動いているプロセスは見ていない
  - 修正案:
    - tldr と 2 章の Claude Code 行を "ディスク上の 2.1.306 は静的に修正済み. 稼働中のセッションは起動時点の旧版 (2.1.296) で動いており再起動が必要" に訂正する
    - 3 章の最後に "全 Claude Code セッションを終了して起動し直す" を追加する. 実施者の Claude はこのセッション自身なので自分では行えない. owner は Jxck, 完了判定は次の 4-4
    - 4-4 を "稼働中の全 claude プロセスの実体が emSign 0 件の版であること" に置き換え, 旧版はディスク上に残っても判定対象外と明記する. 例: `for p in $(pgrep -x claude); do readlink /proc/$p/exe; done` が全て 2.1.306 以降を指し, かつ `readlink -f ~/.local/bin/claude` と cask 実体の静的確認 (ISRG >= 1, emSign = 0) が通ること
2. **GATE が証拠の欠落を検出しない (round 1 の 1 の "件数で定義" が未実装)**
  - `--chains` を付け忘れるか存在しない dir を渡すと, openssl 行は黙って出ず, 他が全て REJECTED なら `GATE: PASS` になる. 4-3 の "openssl オフライン行 (system / brew) も全て REJECTED" は GATE の計算に入っていない. なお展開先の 1 つ上の dir (`chains.zip` と `chains/` がある dir) を渡した場合は zsh の `no matches found` で異常終了して GATE 行が出ないので, こちらは fail-closed
  - 陽性対照の結果が空文字だと, `${P[$k]:-"n/a (offline)"}` の `:-` が空も置換するので "n/a (offline)" として素通りする (zsh で `P[x]=""; echo ${P[x]:-n/a}` が `n/a` になることを確認). `tail -1` が空になりうる node / bun / deno などで陽性対照が無効化される
  - client ごとの行数 (= テストホスト数) と期待する client の集合を検査していないので, 行や client が欠けても PASS しうる
  - 修正案: `--chains` を必須にし, GATE ループを期待 client の列挙に置き換える

```sh
# 引数処理の直後
[[ -d $CHAINS ]] || { print -u2 -- "--chains DIR is required"; exit 2; }

# SUMMARY / GATE (既存の keys ループの置き換え)
required=("curl(brew)" "curl(system)" "wget(brew)" node bun deno go "python(brew)" "python(system)" "ruby(brew)" "git(brew)" "git(apt)" "pnpm(native-store)" "openssl(system store)" "openssl(brew store)")
for k in $required; do
  t=${T[$k]:-0}; r=${R[$k]:-0}; e=${E[$k]:-0}; p=${P[$k]-MISSING}
  [[ $k == openssl* ]] && p=n/a
  [[ $k == pnpm* ]] && want=1 || want=${#hosts}
  print -- "SUMMARY\t$k\tTRUSTED=$t\tREJECTED=$r\tERROR=$e\tPOSITIVE=$p\tROWS=$(( t + r + e ))/$want"
  ok=1
  (( t + r + e == want )) || ok=0
  [[ $p == TRUSTED || $p == n/a ]] || ok=0
  (( e > 0 )) && ok=0
  (( t > 0 )) && [[ " ${EXPECT_TRUSTED:-} " != *" $k "* ]] && ok=0
  (( ok )) || { gate=FAIL; bad+=($k); }
done
```

  - 問題なしと確認した点: テストホストの leaf は 2027-05-03 まで有効なので, 期限切れで全 client が "証明書エラー = REJECTED" になる fail-open は今回の時間軸では起きない. git / pnpm の REJECTED 語は `certificate` 単体を含むので CA ファイル不在なども REJECTED になるが, その場合は陽性対照も同じ理由で落ちる (上の修正で空の陽性対照も FAIL になる)

### Minor

3. **pnpm の native-store probe は妥当だが, 同梱ルート束への fallback がある** (round 1 の 10)
  - 妥当性: pnpm 12.10.1 は Rust 製 (reqwest 0.13.4 + rustls-platform-verifier 0.7.0 + rustls-webpki 0.103.15). `SSL_CERT_FILE` を ISRG のみにすると registry.npmjs.org を `invalid peer certificate: UnknownIssuer` で拒否する (再現). 通常時はシステムストアだけを使うので, openssl(system store) 行と 4-1 のハッシュディレクトリ確認で代替する設計は成り立つ
  - ただしバイナリは `emSign ECC Root CA - G3` を含む DER のルート束 (Mozilla 系一式) を同梱しており, `SSL_CERT_FILE` を空ファイル, `SSL_CERT_DIR` を空 dir にすると registry.npmjs.org に成功した. つまりストアが空または読めないときは同梱束 (emSign 入り) に fallback する. 最新の 12.14.0 も同梱束に emSign があり rustls-webpki 0.103.15 のままで, pnpm 側の修正版は無い. 2 章の pnpm 行にこの点を書き, 7 章に追跡行を足す
  - この行は修正の前後で結果が変わらない構造チェックである (ベースラインで pnpm だけが GATE を通っている). 現状 AAA 側は 2s で UnknownIssuer, emSign 側は 25s 超無応答 (実測) なので, 修正後は emSign 側も即座に拒否されるはず. after の実行に限り per-host probe を `timeout 30` 付きで足すと直接の証拠になる (無応答は ERROR = fail-closed)
4. **4-4 の mise probe の合格条件が誤読しうる** (round 1 の 3)
  - 置換先が失敗すると mise は `https://deno.com/versions.json` に fallback し, そちらの `200 OK` が出る (現状の出力: 置換先 `200 OK` -> `TOML parse error` -> deno.com `200 OK`). `head -2` の 2 行目が別ホストの 200 になりうる
  - 合格条件を "`we-have-a-problem.com` を含む行に `200 OK` が無く, 同ホストへの certificate エラー行があること" と書く. また npm backend はテストホストが無応答で実通信 probe が成立しないので, 版 (2026.10.17) でのみ確認している旨を明記する
5. **3-6 の certbot probe は成立する. 3 点補足** (round 1 の 6)
  - 確認: `/snap/certbot/current/bin/python3 -> ../usr/bin/python3.12` (snap 同梱 3.12 の venv), httpx 0.28.1 は plugin snap 側にあり `_config.py` で `SSL_CERT_FILE` を読む. 非 root で certifi 経由 200, `SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt` (3-1 前) 200, `SSL_CERT_FILE=<ISRG のみ>` で `CERTIFICATE_VERIFY_FAILED` を実測した. `show_account` は acme の `_get_v2_account` で `newAccount` に `onlyReturnExisting: true` を POST するだけで, アカウントは作らない (読み取り). 既存の drop-in は無い (`DropInPaths=` 空)
  - (a) plan の httpx probe 2 本は 3-1 前だとどちらも 200 で何も検証しない. ISRG のみの `SSL_CERT_FILE` を陰性対照として足すと, 3-1 前でも "httpx が `SSL_CERT_FILE` を読む" ことを示せる
  - (b) `PYTHONPATH` は sys.path の先頭に入るので probe は plugin snap の certifi を使うが, 実行時は certbot が `sys.path.extend` で plugin を後ろに足すため certbot snap の certifi が使われる. 現状は同版で結果は同じだが, 撤去判断は certbot snap 側で行う (plan どおり) ことを明記する
  - (c) 撤去条件は版の比較より, 両 snap の `certifi/cacert.pem` で `grep -c 'emSign ECC Root CA - G3'` が 0 になることの方が確実 (PyPI の certifi 2026.10.18 / 2026.10.19 とも 0 件を確認. 2026.10.18 で既に除外されている)
6. **ロールバック節の細部** (round 1 の 5, 15)
  - (a) `brew upgrade` は既定で対象 formula の旧 keg をその場で cleanup する (`HOMEBREW_NO_INSTALL_CLEANUP` は未設定. 現状 Cellar の ca-certificates / mise / curl は各 1 版のみ). "mise は brew の旧 keg が brew cleanup まで残る" は誤り. 戻す余地が要るなら 3-2 に `HOMEBREW_NO_INSTALL_CLEANUP=1` を足し, 不要なら文言を削る
  - (b) ws の `ExecStart` 差し替えは, drop-in で先に空の `ExecStart=` を書かないと Type=simple では重複エラーになる. より単純な代替は `mise uninstall node@26.12.1` で `installs/node/latest` が 26.11.1 に戻ることを確認して restart する方法 (`.mise.toml` は触らない)
  - (c) `/usr/local/share/ca-certificates/` への局所追加は, Homebrew の `cert.pem` には post_install 時にしか入らない. brew 側も要るなら `brew postinstall ca-certificates` を併記する
7. **TBD-3 の根拠の書き方** (round 1 の 4)
  - 決定自体に異論は無い. ただし "mise は checksum 検証付きで取得する" は同じ配布元のハッシュなので, 撤回されるような不良リリースへの防御にはならない. 実際に効いているのは "3-1 / 3-2 で取得経路を直してから取る" 順序と, 対象が vendor のセキュリティリリースであること. 根拠をそう書き直す
  - node は 2026-10-22 09:00 JST に eligible になる. 実施が 09:00 以降にずれた場合, node には `--minimum-release-age 0s` は不要 (deno は 2026-10-23 00:28 JST まで必要)
8. **版の確認がシェルの PATH に依存する** (4-2, 4-5)
  - mise を activate したシェルは `installs/deno/2.9.7/bin` や `installs/go/1.27.1/bin` を PATH に直接持つ (このレビューの環境の `which -a` で確認). hook-env が走らない agent の Bash では, upgrade 後も `deno --version` や `go version` が旧版を返しうる. 4-2 は `~/.local/share/mise/shims/<tool>`, `mise ls`, check.sh の版列のいずれかで判定する
  - `brew upgrade` は auto-update を伴うので, 実施時に dry-run より新しい版が来うる. 4-2 の期待値は "実施直前の dry-run の版以上" とする
  - 4-5 に `readlink /proc/$(systemctl show -p MainPID --value ws)/exe` が 26.12.1 を指すことを足す (再起動の目的が binary の差し替えなので)
9. **rustup は任意でなく実施に寄せる** (round 1 の 9)
  - 1.29.1 は reqwest 0.13.4 + rustls-platform-verifier 0.7.0 + rustls-webpki 0.103.13 で, 同梱ルート名は 0 件 (strings). システムストアで直るという判断は妥当
  - ただしアドバイザリは Rustup 1.29.2 と rustls-webpki 0.103.16 自体を patched version に挙げており, ルートに依存しない遮断が webpki 側に入っていると読める (未検証). 費用が小さいので 3-4 を必須にし, 4-2 に `rustup --version` を足す
10. **TBD-6 の前提: Linux の cask は Brewfile 管理ではない**
  - Brewfile の cask は全て `if OS.mac?` の中 (claude-code は 110 行目) で, README も "Cask は macOS 専用" と書く. `update.sh` は `brew upgrade --formula` のみ. つまりこのホストの cask は方針外に手で入れたもので, 2.1.304 に上げても再び放置される. TBD-6 の "Homebrew cask (Brewfile 管理, 手動更新)" と, 7 章の README 文言の行は前提が違う (Linux では cask があること自体が逸脱)

### TBD-6 への推奨

- このホストでは native に寄せ, cask は `brew uninstall --cask claude-code` で外す. Brewfile は mac 用なので変更不要. 理由: native は自動更新で修正版 (2.1.306) を既に受け取っている. Linux の cask は Brewfile と `update.sh` のどちらの管理下にも無く必ず陳腐化する. PATH 上も shadow されていて, dotfiles 内に cask のパスを参照する箇所も無い (grep で確認)
- 本 plan の 3-2 の `brew upgrade --cask claude-code` は uninstall に置き換えてよい. 即決できない場合は upgrade で暫定とし, 4-4 の cask 静的確認を残す
- どちらを選んでも本題は major 1 のセッション再起動. 自動更新はディスク上の版しか変えないので, 長時間動いているセッションが旧版のまま残るという運用上の性質を 7 章に書いておく
- Mac 側は Brewfile で cask を入れているので別判断とする (Mac で cask の版が追従しているかを確認する)

## Answer by Claude (round 2) (2026-10-22)

approve を受けて Fixed 化した。round 2 の finding は全て受け入れ、本文に反映した。

- major 1: 稼働中プロセスの `/proc/<pid>/exe` が 2.1.296 (Bun v1.4.3、emSign 2 件 / ISRG 2 件) であることを再現した。tldr / 2 章を訂正し、3-7 (セッション再起動、owner Jxck) を追加、4-4 を「稼働中の全 claude プロセスの実体」で判定するように変更
- major 2: check.sh v2 に `--chains` 必須化、必須 client 16 種の列挙、行数 (ROWS=n/want) の検査、空の陽性対照の FAIL 化を入れた (提示されたパッチを採用し、per-host の pnpm 行を加えたので `pnpm` を必須 client に追加)。`--chains` 無しで rc=2、quick 実行で全 client の ROWS が揃うことを確認
- minor 3: pnpm の同梱束 fallback を 2 章と 7 章に記載。修正後の直接証拠として per-host の pnpm 行 (timeout 30、無応答は ERROR) を check.sh に追加
- minor 4: mise probe の合格条件をホスト名で読み分ける形に修正。npm backend は版でのみ確認する旨を明記
- minor 5: certbot probe に ISRG のみの陰性対照を追加、`PYTHONPATH` と実運用の certifi の違いを明記、撤去条件を `cacert.pem` の grep に変更
- minor 6: ロールバック節を修正 (brew は旧 keg をその場で cleanup、ws は `mise uninstall node@26.12.1` で `latest` を戻す、`/usr/local/share/ca-certificates/` 追加時は `brew postinstall` を併記)
- minor 7: TBD-3 の根拠から checksum の記述を外し、「vendor のセキュリティリリース」「取得経路を直してから取る」に改めた。実施順の変更 (下記) に伴い、取得は修正済み brew ストアを `SSL_CERT_FILE` で指定して行う予定だったが、実施時に無効と判明したため Homebrew curl による独立再取得との一致確認に置き換えた (3-3 の「実施時の訂正」)
- minor 8: 4-2 を shims / `mise ls` で判定、期待値を「dry-run の版以上」に、4-5 に MainPID の実体確認を追加
- minor 9: rustup を必須にした
- minor 10: TBD-6 と 2 章の cask 行の前提を「Linux の cask は Brewfile / update.sh の管理外」に訂正

追加の変更 (レビュー後に判明): この環境の agent は sudo を使えない (`sudo -n true` が password を要求)。そのため実施順を 3-2 -> 3-3 -> 3-4 (Claude) -> 3-1 / 3-5 / 3-6 / 3-7 (Jxck) に変え、3-3 / 3-4 のダウンロードが未修正の system ストアに依存しないよう `SSL_CERT_FILE` で修正済み brew ストアだけを指定する手順にした。TODO の順序もこれに合わせた。
