# dotfiles for jxck

Jxck の個人 dotfiles

- Mac および Ubuntu で共用
- どちらでも動くように分岐
- スクリプトは基本 zsh, ruby, js


## Setup

- setup/setup.sh を実行 (`-y` で冒頭の確認を省略)
  - linux で依存インストール
  - 共通で homebrew の導入
  - `brew bundle` で Brewfile の Formula/Cask を初回インストール
  - `install/install-claude.sh` で Claude Code を native 版で導入 (brew cask は使わない)
  - slink.sh (既存の実体を置き換えそうな場合は何も変更せずに失敗し、setup.sh もそこで止まる)
  - linux で chsh
- setup/setup-mac.sh
  - macOS の設定を適用 (System Settings 各種, 壁紙, SwiftBar プラグインフォルダ等)
  - 壁紙は `setup/wallpaper.jpg` を使用
  - 一部 sudo が必要 (pmset)
  - 末尾で Dock/Finder/SystemUIServer/ControlCenter を再起動して即時反映
- setup/setup-linux.sh
  - Ubuntu サーバの初期設定 (authorized_keys の取得, sshd の root / password ログイン禁止, ufw)
  - setup.sh からは呼ばれないので個別に実行


## 自動化できないもの

### Settings

- General
  - Open Video Editor: on
- Wallpaper
  - Window screenshots: Transparent
- Users & Groups
  - アイコンを選んでモノグラムの J にする
- Keyboard
  - input source: Google IME Hiragana
  - brightness を 0
- Dock
  - 並べ替えを自動でできない
  - 全部消すスクリプトだけ入れたので自分で育てる
- Menu Bar
  - 表示のオンオフは手動で設定
  - cmd を押しながら並べかえ


### Application

- AltTab
  - `alt-tab/com.lwouis.alt-tab-macos.plist` を import
- Raycast
  - `raycast/*.rayconfig` を Raycast の Import
- CleanShot X
  - GUI に設定 export 機能なし。設定は手動
  - Shortcuts
    - All-in-One: cmd-shift-5
    - Capture Area: cmd-shift-4
    - Capture Fullscreen: cmd-shift-3
    - Capture Area Copy: cmd-shift-ctl-4
- Google IME Hiragana
  - Drive にある util/google-ime-dictionary.txt を import
  - Suggest を全部オフ
- 1Password
  - Use the SSH Agent を On
  - Display Key Name ... On
  - Generate SSH Config file ... On


## ディレクトリ構成

- bin/: カスタムスクリプト
- zsh/: zsh のモジュール別設定 (mac.zsh, common.zsh, fzf.zsh 等)
- install/: ビルド・インストールスクリプト
- setup/: OS 別セットアップスクリプト
- conf/: 各種ツールの設定ファイル
- tmux/: OS 別 tmux 設定
- keys/: TLS 証明書・SSH 鍵 (読まない・変更しない)


## 主要ファイル

- .zshrc: シェル設定のエントリポイント
- .gitconfig: git 設定 (delta, GPG 署名, エイリアス)
- .tmux.conf: tmux 設定 (prefix は C-s, vi モード)
- .vimrc: vim 設定
- .mise.toml: ツールバージョン管理 (node, deno, bun, go, rust 等)
- Brewfile: Homebrew パッケージ一覧 (Cask は macOS 専用)


## 1Password

まず 1Password で SSH Agent を有効にする。

```
1password > Settings > Developer > Set Up SSH Agent
```


## cmux

ターミナルは cmux (内部で Ghostty を使用)。

- Brewfile で導入 (tap `manaflow-ai/cmux` の cask)
- 設定は `cmux/cmux.json`。`bin/slink.sh` が `~/.config/cmux/cmux.json` に symlink する
- TERM=xterm-ghostty を設定するため、SSH 先に terminfo が必要
- SSH 先への terminfo インストール: `infocmp -x xterm-ghostty | ssh <host> tic -x -`
- cmux のシェル内で実行すること (cmux が terminfo を持っている)


## 構成

- .agents
  - AGENTS / skill の**正本**置き場 (Claude / Codex 共用)
  - AGENTS.md: 全 agent 共通の指示 (`.claude/CLAUDE.md` と `.codex/AGENTS.md` から symlink される)
  - plan/: 実装プラン (`planning` skill が生成) と、実装後の HTML report
  - skills/: 全 repo から見える global skill の正本
    - repo 内は `.claude/skills` と `.codex/skills` がディレクトリごと symlink
    - home 側は `bin/slink.sh` が `~/.claude/skills` と `~/.agents/skills` を張る (Codex は `~/.agents/skills` を読む)
    - `~/.codex/skills` は Codex が `.system/` を置く実 directory なので触らない
    - skill は global (ここ) と repo (各 repo の `.agents/skills`) の二層。同じ名前を両方に置かない
    - repo 固有の値は各 repo の `.agents/bindings/<skill>.md` に置き、global skill がそれを読む
    - `bin/skill-check <global root> [<repo root>...]` で名前の衝突と配線を検査する
    - planning: 実装プランの作成と Agent 間相互レビュー (`.agents/plan/` に生成)
    - install-creator: `install/install-<name>.sh` の作成手順
    - permission-sync: `.claude/settings.json` と `.codex/rules/default.rules` の同期
    - skill: skill の作成 / 修正 / 一覧 / 監査 (global と repo の二層の判定基準を持つ)
    - commit-message: `[area] summary` 形式の commit message の規約
    - review-criteria: plan と code の review に共通する規律と観点カタログ (`planning` が参照する)
    - sync: 未 commit の変更の commit から rebase、push までを行い、upstream との差分を 0 にする
    - writing: 読みにくい日本語の文章を、意味を変えずに構造から直す (計測は同じ directory の `measure.py`)
    - env-boundary: 開発環境の値 (origin / port / path / secret) を成果物に漏らさないための確認
    - hard-task-protocol: 難しいタスクの分解・検証・次の一手の決め方
    - Cloudflare 系 11 個 (cloudflare / wrangler / agents-sdk など): 外部由来
- .claude
  - Claude Code 設定
  - CLAUDE.md と skills/ は `.agents/` への symlink
  - agents/: 全 repo 共通の subagent 定義 (`deep-reasoner` / `implementer` / `fast-worker`)。home 側は `~/.claude/agents` が指す
  - settings.json はここを正本とする
- .codex
  - Codex CLI 設定
  - AGENTS.md と skills/ は `.agents/` への symlink
  - agents/: 同じ 3 つの subagent の Codex 版。home 側は `~/.codex/agents` が指す
  - config.toml と rules/ はここを正本とする
- .cargo
  - Cargo の設定 (config.toml)。`~/.cargo/config.toml` に symlink される
- .ssh
  - macOS 用の SSH 設定 (config) と、1Password の agent socket への symlink (1password.sock)
  - `~/.ssh/config` に symlink されるのは macOS だけ (下記)
- .vscode
  - VS Code 用辞書ファイル (cspell.txt)
- alt-tab
  - AltTab の設定 (com.lwouis.alt-tab-macos.plist)
- bin
  - 自作コマンド置き場
  - $PATH が通してある
  - 基本は ruby か shell で書く
  - slink.sh: home への symlink を張る (下記)
  - update.sh / upgrade.sh: 依存の更新 (下記)
  - skill-check: skill の名前の衝突と配線の検査
- cmux
  - cmux の設定 (cmux.json)。`~/.config/cmux/cmux.json` に symlink される
- conf
  - apt.conf, prh.yml など
- install
  - 自前ビルドするスクリプト
  - `install-*` で作る
- keys
  - https コマンド用のローカル key/cert
- linearmouse
  - LinearMouse 設定 (linearmouse.json)。`~/.config/linearmouse/linearmouse.json` に symlink される
- local
  - `install-*` が pkg でビルドしたあと make install する先
  - `--prefix` などに指定する先
  - 個別に PATH を通す
- misc
  - 昔作った bookmarklet と snippet の残骸
- pkg
  - `install-*` がソースをダウンロードする場所
  - そのままビルドして PATH を通しても良い
- raycast
  - Raycast の設定 (.rayconfig)
- setup
  - OS 別セットアップスクリプト (setup.sh, setup-mac.sh, setup-linux.sh)
  - wallpaper.jpg: setup-mac.sh で設定するデスクトップ壁紙
- swiftbar
  - SwiftBar プラグイン (SSID 表示, 時刻表示)
- tmux
  - mac/linux 用 tmux.conf
- zsh
  - .zshrc で読み込む個別設定
  - `brew.shellenv.*.zsh` / `op.completion.zsh` / `mise.completion.zsh` は `update.sh` が再生成するキャッシュ


## home への symlink (bin/slink.sh)

`bin/slink.sh` が dotfiles の中身を home に symlink する。何度実行しても同じ結果になる。

- `.gitconfig` / `.zshrc` / `.tmux.conf` / `.vimrc` / `.vim` などの dotfile を `~/` 直下に張る
- `.claude/` と `.codex/` の中身を、1 つずつ `~/.claude/` と `~/.codex/` に張る
- skill と subagent の link を張る (下の図)
- `linearmouse.json` / `cmux.json` を `~/.config/` 配下に、`.cargo/config.toml` を `~/.cargo/` に張る
- `.ssh/config` は macOS でだけ、`~/.ssh/config` が無い場合に張る
  - 1Password の agent socket の path を持つ macOS 専用の設定である
  - Linux に張ると、転送された agent が使えなくなり、SSH の認証が全て失敗する
- 変更の前に link 先を検査する。実 directory を置き換えそうな場合や、skill / subagent の link 先に想定外の実体がある場合は、何も変更せずに失敗する

skill / subagent / agent 向け指示の配線は次のとおり。`==>` は symlink。

```
 ~/
 +-- .claude/
 |   +-- skills     ==>  ~/dotfiles/.claude/skills  (==> ../.agents/skills)
 |   +-- agents     ==>  ~/dotfiles/.claude/agents
 |   +-- CLAUDE.md  ==>  ~/dotfiles/.claude/CLAUDE.md  (==> ../.agents/AGENTS.md)
 +-- .agents/
 |   +-- skills     ==>  ~/dotfiles/.agents/skills
 |   +-- log/            (実 directory)
 +-- .codex/
     +-- agents     ==>  ~/dotfiles/.codex/agents
     +-- AGENTS.md  ==>  ~/dotfiles/.codex/AGENTS.md   (==> ../.agents/AGENTS.md)
     +-- skills/         (実 directory。Codex が置く .system/ だけ)
```

- Claude Code は `~/.claude/skills`、Codex は `~/.agents/skills` を読む。どちらも `.agents/skills/` に辿り着く
- skill の追加や修正は pull するだけで反映される。`slink.sh` の再実行が要るのは、home 側の link を増やすときだけ


## コマンド作成

- alias
  - ./zsh/common.zsh
- zsh function
  - ./zsh/common.zsh
- shell
  - ./bin
  - `#!/usr/bin/env zsh` で書く
  - `-h` を作る
- ruby
  - ./bin
  - `#!/usr/bin/env ruby` で書く
  - `-h` を作る
  - ./bin/template を参照


## 依存の追加

- 基本は homebrew の bundle に追加
  - Formula は linux / mac で使えるようにする
  - Cask は `if OS.mac?` に追加する
  - 自動更新機能を持つ Cask の更新は各アプリに任せる (それ以外は `update.sh` で更新)
  - 追加後は `brew bundle`、削除後は `update.sh` で反映
  - 一時的なものは `brew install` して終わったら捨てる
- 言語処理系と、npm / go で入れる CLI
  - `.mise.toml` に追加する (`npm install` は使わない)
- 自前ビルド
  - `./install/install-xxx.sh` を作る
  - `./pkg/xxx` と `./local/xxx` を削除
  - `./pkg/xxx` にソースをダウンロード
  - そこでビルドして終わりなら PATH 追加して終わり
  - make install するなら `--prefix=$DOTFILES/local/xxx` を指定
  - 詳細な判定フローとパターンは `install-creator` skill を参照


## update/upgrade

`upgrade.sh` は `update.sh` を実行する。

`update.sh` は次の順に実行する。

- Linux では apt の更新
- brew の更新 (下記)
- `.zshrc` が読むキャッシュ (`zsh/brew.shellenv.*.zsh` / `zsh/op.completion.zsh` / `zsh/mise.completion.zsh`) の再生成
- mise の更新 (`mise upgrade --bump`) と不要な版の削除
- dotfiles と jxck.io の fetch (jxck.io は `npm ci` も行う)
- `cleanup.sh` (home の不要な dotfile の削除)

brew は Formula と自動更新機能のない Cask を更新し、Brewfile にない Formula / Cask を削除する。
自動更新機能を持つ Cask は brew では更新せず、各アプリの更新機能に任せる (`.zshrc` と `update.sh` で `HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS` を設定)。
Brewfile に追加したら `brew bundle` を実行する。`.zshrc` で `HOMEBREW_BUNDLE_NO_UPGRADE` を設定しているので、追加分のインストールだけを行う (更新もしたい場合は `brew bundle --upgrade`)。

Homebrew 版 curl は HTTP/3 対応のため Brewfile で管理する。
`.zshrc` では `mise activate zsh` の後に PATH を追加し、macOS 標準の curl より優先する。

```sh
$ update.sh
$ upgrade.sh
```


## gnome settings

Ubuntu terminal

```sh
$ dconf dump /org/gnome/terminal/ > gnome-terminal-profiles.dconf
$ dconf reset -f /org/gnome/terminal/
$ dconf load /org/gnome/terminal/ < gnome-terminal-profiles.dconf
```


## tips

### zsh/http_status_codes.zsh

ステータスコードを打つとステータステキストが出る

```sh
$ 203
Non-Authoritative Information [RFC7231]
```


### bin/http, bin/https

Webrick ベースの簡易 HTTP/HTTPS サーバ。その場を Root に起動する。

```sh
$ http
```

HTTPS を使う場合は `$DOTFILES/keys/privkey.pem` と `$DOTFILES/keys/fullchain.pem` を使う。

- `keys/gen.sh`: ローカルで key/cert を作る
- `keys/remote-copy.sh`: サーバで Let's Encrypt で作った証明書をダウンロード
- `keys/local-copy.sh`: ローカルで証明書をコピー
- `keys/use.sh`: メインで使いたい証明書の symlink を作る


### bin/l

Ruby で作った、痒いところを全部カバーした自作 ls

`ls` は置き換えていない。`ll` と `la` は alias である。

```sh
$ l
# $DOTFILES/bin/l

$ ll
# l -ah

$ la
# l -a
```


## Shell Coding

### if / then / else

- `[` や `test` ではなく `[[` を使う
- 論理演算は `&&`, `||` を使う

```sh
if [[ `uname` == "Darwin" ]]; then
  echo "install via brew"
  exit 0
fi
```


### 変数の有無

- 無い場合: `-z` で文字列長が 0 かどうかを比較
- 有る場合: `-n` で文字列長が 1 以上かどうかを比較

```sh
if [[ -f "/opt/homebrew/bin/mise" ]]; then
  eval "$(mise activate zsh)"
  export MISE_GLOBAL_CONFIG_FILE=$DOTFILES/.mise.toml
fi

if [[ -n $DEV ]]; then
  echo "fetch jxck.io"
  cd $DEV/jxck.io
  git f
fi
```


### 文字列比較

- `[[` を使う場合、ダブルクオートの有無で完全一致かマッチを使い分けられる。
- また `=~` でもマッチが使える。
- しかし、それだとややこしいので `==` か `!=` と `*"string"*` 構文を組み合わせる。

```sh
## webp
if [[ -d "$DOTFILES/pkg/webp" && $PATH != *"/pkg/webp/bin"* ]]; then
  echo "webp"
  addToPath $DOTFILES/pkg/webp/bin
fi
```


### コマンドの存在

```sh
if [[ -x "$(command -v brew)" ]]; then
  echo "brew exists"
fi
```


### $PATH

パスの追加(`$PATH=/path/to/file:$PATH`)をする関数 `addToPath` があるので使う。

zsh で `typeset -U path` を設定し、重複を省いてある。

```sh
## openssl
[[ -d "$DOTFILES/local/openssl/bin" ]] && addToPath $DOTFILES/local/openssl/bin

## webp
if [[ -d "$DOTFILES/pkg/webp" && $PATH != *"/pkg/webp/bin"* ]]; then
  echo "webp"
  addToPath $DOTFILES/pkg/webp/bin
fi
```


### for

基本はこの書き方

```sh
target_files="
a
b
c
"

for target in $target_files
do
  echo $target
done
```


## TODO

- [eMudhra 中間 CA 漏えい対策 (conoha)](.agents/plan/20261022-0237-emudhra-ca-compromise.md) ([report](.agents/plan/20261022-0237-emudhra-ca-compromise.html)): 対策と acceptance は 2026-10-22 に完了。残フォローアップ (plan 7 章): Bun stable の修正版 (1.4.4 以降) が出たら `update.sh` 後に check.sh で bun の TRUSTED 0 を確認し mozaic.fm / vtt.mozaic.fm を再起動、pnpm 同梱ルート束の修正版、certbot snap の certifi から emSign が消えたら `sudo systemctl revert snap.certbot.renew.service`、Mac 側に同対策
- [自作 skill の dotfiles 一元管理と repo 間共有](.agents/plan/20261127-0117-shared-skills.md) ([report](.agents/plan/20261127-0117-shared-skills.html)): 2026-11-27 に完了 (subagent 3 種と `skill` / `commit-message` / `review-criteria` / `sync` / `writing` を global 化。3 repo とも push 済みで、VPS の dotfiles と配線も反映済み)。残りは VPS での mozaic.fm / jxck.io の pull、Mac と VPS の `~/.codex/skills.retired-*` の削除、Phase 2 (`makefile` / `docs` / `fixup`)
