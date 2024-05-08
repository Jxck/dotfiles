# dotfiles for jxck

## 構成

- tmux
  - mac/linux 用 tmux.conf
- zsh
  - .zshrc で読み込む個別設定
- bin
  - 自作コマンド置き場
  - $PATH が通してある
  - 基本は ruby か shell で書く
- install
  - 自前ビルドするスクリプト
  - `install-*` で作る
- pkg
  - `install-*` がソースをダウンロードする場所
  - そのままビルドして PATH を通しても良い
- local
  - `install-*` が pkg でビルドしたあと make install する先
  - `--prefix` などに指定する先
  - 個別に PATH を通す
- keys
  - https コマンド用のローカル key/cert
- conf
  - conf 系だが今はあまり使ってない
- misc
  - 昔作った bookmarklet の残骸
- snip
  - 昔作ったスニペットの残骸
- systemd
  - 昔の自作サーバで動かしてたデーモンの残骸
- crontab
  - .zsh_history 共有用に使ってたタスクの残骸


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
  - linux / mac で使えるように
  - 必ずはいらない場合は `brew install` して終わったら捨てる
- 自前ビルド
  - `./install/xxx-install.sh` を作る
  - `./pkg/xxx` と `./local/xxx` を削除
  - `./pkg/xxx` にソースをダウンロード
  - そこでビルドして終わりなら PATH 追加して終わり
  - make install するなら `--prefix=$DOTFILES/local/xxx` を指定


## update/upgrade

今となってはどっちもそこまで変わらなくなってきた。

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

### zsh/http_status_code.zsh

ステータスコードを打つとステータステキストが出る

```sh
$ 203
Non-Authoritative Information [RFC7231]
```


### bin/http, bin/https

Webrick ベースの簡易 HTTP/HTTPS サーバ。その場を docroot にする。

```sh
$ http
[2019-05-06 15:36:45] INFO  WEBrick 1.3.1
[2019-05-06 15:36:45] INFO  ruby 2.3.7 (2018-03-28) [universal.x86_64-darwin18]
[2019-05-06 15:36:45] INFO  WEBrick::HTTPServer#start: pid=33328 port=3000
```

HTTPS を使う場合は `$DOTFILES/keys/privkey.pem` と `fullchain.pem` を使う。

- `/keys/gen.sh`: ローカルで key/cert を作る
- `/keys/remote-copy.sh`: サーバで Let's Encrypt で作った証明書をダウンロード
- `/keys/use.sh`: メインで使いたい証明書の symlink を作る


### bin/l

Ruby で作った、痒いところを全部カバーした自作 ls

```sh
$ ls
# $DOTFILES/bin/l

$ \ls
# /bin/ls
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


## 変数の有無

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


## 文字列比較

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


## コマンドの存在

```sh
if [[ -x "$(command -v brew)" ]]; then
  echo "brew exists"
fi
```


## $PATH

パスの追加(`$PATH=/path/to/file:$PATH`)をする関数 `addToPath` があるので使う。

zsh で `typeset -U path PATH` で重複を省いてある。

```sh
## openssl
[[ -d "$DOTFILES/local/openssl/bin" ]] && addToPath $DOTFILES/local/openssl/bin

## webp
if [[ -d "$DOTFILES/pkg/webp" && $PATH != *"/pkg/webp/bin"* ]]; then
  echo "webp"
  addToPath $DOTFILES/pkg/webp/bin
fi
```


## for

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