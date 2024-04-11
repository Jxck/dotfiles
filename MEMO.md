# dotfiles for jxck


## hierarchy

- bin
  - utility commands written in ruby/shell etc
  - this dirs are in $PATH
- conf
  - config file templates
- install
  - used in ./install scripts
- keys
  - sample tls key/cert for testing
- local
  - used in ./install scripts
- misc
  - something
- pkg
  - used in ./install scripts
- snip
  - snippets
- tmux
  - tmux.conf for platform
- zsh
  - zshrc imported by .zshrc


## write commands

- alias
  - in ./zsh/common.zsh
- zsh function
  - in ./zsh/common.zsh
- shell
  - in ./bin
  - basically onliner
- ruby
  - in ./bin
  - long program
  - add `-h` for HELP
  - see ./bin/template


## install something

- write xxx-install.sh into ./install
- clean dest dir first
- download to ./pkg
- if compiled, add ./pkg/path/to/bin to $PATH via .zshrc
- if source, comile to ./local and add ./local/path/to/bin to $PATH via .zshrc
- via `./configure --prefix=$DOTFILES/local/xxxx`


## update/upgrade

update packages via bin/update.sh or bin/upgrade.sh


```sh
$ update.sh
$ upgrde.sh
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


```sh
$ 203
Non-Authoritative Information [RFC7231]
```


### bin/http, bin/https

http starts local http server with current directory as doc root.


```sh
$ http
[2019-05-06 15:36:45] INFO  WEBrick 1.3.1
[2019-05-06 15:36:45] INFO  ruby 2.3.7 (2018-03-28) [universal.x86_64-darwin18]
[2019-05-06 15:36:45] INFO  WEBrick::HTTPServer#start: pid=33328 port=3000
```

if use https, it serve https using /keys/key.pem, /keys/cert.pem as default.

if you have own key/certs, use it via simlink to /keys or args for https command.

or use ./keys for sample sue.


### bin/l

l is ruby implementation of ls.

it's aliased to ls so need /bin/ls add `\` to prefix.


```sh
$ ls
aliased to l

$ \ls
use /bin/ls
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


## $PATH

パスの追加は `$PATH=/path/to/file:$PATH` 的な上書きでの重複を避けるために `addToPath` を使う


```sh
## openssl
[[ -d "$DOTFILES/local/openssl/bin" ]] && addToPath $DOTFILES/local/openssl/bin

## webp
if [[ -d "$DOTFILES/pkg/webp" && $PATH != *"/pkg/webp/bin"* ]]; then
  echo "webp"
  addToPath $DOTFILES/pkg/webp/bin
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
