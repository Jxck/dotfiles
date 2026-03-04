function tmuxh() {
  cat <<EOF
C-s C-r     # tmux.conf リロード
C-s C-c/c   # 新規ウィンドウ
C-s C-n/n   # 次のウィンドウ
C-s C-p/p   # 前のウィンドウ
C-s h/j/k/l # ペイン移動 (vi 風)
C-s C-h/C-l # リサイズ 左/右
C-s C-j/C-k # リサイズ 下/上
C-s C-o     # ペイン入れ替え
C-s 1       # 右にペイン分割
C-s 2       # 下にペイン分割
C-s 3       # 左にペイン分割
C-s 4       # 上にペイン分割
C-s 0       # ペインをウィンドウに切り出す
C-s 8       # 現在のペインを左メインにする
C-s 9       # ペインを閉じる (確認なし)
EOF
}

function zshh() {
  cat <<EOF
alias -g N="1>/dev/null 2>/dev/null"          # No Output
alias -g B="1>/dev/null 2>/dev/null &"        # Background
alias -g A="2>&1"                             # All (merge stdout/err)
alias -g C="2>&1 | color"                     # Color (All then colorize)
alias -g H="| xxd -g 1 -c 4"                  # Hex
alias -g V="2>&1 | vim -c 'au! CursorHold' -" # Vim from stdout
alias -g PP="|&pp"                            # PanicParse (golang)
alias -g T="| tee -a /dev/stderr"             # Tee to stderr
alias -g S="| sort | uniq"                    # Sort
alias -g U="| sort | uniq -c | sort -nr"      # Count
alias -g UU="| sort | uniq -c | sort -n | sed -E 's/^ +[0-9]+ //g'" # No Number
alias -g W="2>&1 | btee"                      # Window in browser
alias -g L="| awk ... | sort -n | uniq | cut" # Sort by Length
alias -g LL="| length-count-sort.rb"          # Sort by Length
alias -g LS="| less -S"                       # Shorten long lines
EOF
}

function lessh() {
  cat <<EOF
[line count] $ less -M
[show ansi]  $ less -R
[nowrap]     $ less -S
[tail -f]    $ Shift+F
[grep]       $ &word
[grep -v]    $ &!word
EOF
}

function gith() {
  cat <<EOF
[push branch]  $ git push origin dev
[ck branch]    $ git checkout -b dev origin/dev
[del branch]   $ git push origin :dev
[sync branch]  $ git fetch --prune
[pull force]   $ git fetch --all && git reset --hard origin/main
[clone submod] $ git submodule init && git submodule update
[up submod]    $ git submodule foreach 'git pull origin main'
[patch]        $ git diff --no-prefix HEAD~ > my.patch
[apply]        $ patch -p0 < my.patch
[shallow]      $ git clone --depth 1 https://github.com/git/git
[update old]   $ git rebase main old-branch
EOF
}

function greph() {
  cat <<EOF
[ignore]  $ grep -v
[only]    $ grep -o
[exclude] $ grep --exclude-dir=pkg
[no name] $ grep -h
[unicode] $ grep "$(printf '\uFE0F')" ./**/*.html
EOF
}

function sedh() {
  cat <<EOF
[infile]  $ sed -i
[regexp]  $ sed -r
[replace] $ sed -ir 's/a/A/g' ./**/*.html
EOF
}

function findh() {
  cat <<EOF
[name] $ find ./ -name *.md
[each] $ find ./ -name *.md | xargs -L 1 echo
EOF
}

function dockerh() {
  cat <<EOF
[build]  $ docker build -t name/image:1.1 .
[run]    $ docker run -d -p 3000:80 name/image:2.0
[exec]   $ docker exec -it CONTAINER bash
[logs]   $ docker logs -f CONTAINER
EOF
}

function vimh() {
  cat <<EOF
Window
[rotate]  <C-w> r
[move]    <C-w> [k/j/h/l]
[horiz]   <C-w> K
[vert]    <C-w> H

Resize
[up]    <C-E><C-k>
[down]  <C-E><C-j>
[left]  <C-E><C-h>
[right] <C-E><C-l>

Tab
[open]  <C-t><C-o>
[close] <C-t><C-c>
[next]  <C-t><C-n>
[prev]  <C-t><C-p>

CLI
$ vim +command +qall
$ vim -c 'Command' -c 'qa!'
EOF
}

function curlh() {
  cat <<EOF
[show header]  --include
[ignore cert]  --insecure
[post]         -X POST -d 'aaa=bbb&ccc=ddd'
[post JSON]    -X POST -H "Content-Type: application/json" -d 'aaa=bbb&ccc=ddd'
EOF
}

function chromeh() {
  cat <<EOF
$ git rebase-update
$ gclient sync
$ git checkout -b feature-2222222
$ git cl patch 2222222
$ autoninja -C out/Default chrome
EOF
}

function rgh() {
  cat <<EOF
$ rg test      # ディレクトリ内で再帰検索
$ rg -i wod    # 大文字小文字無視
$ rg -w word   # 単語検索
$ rg -e word   # 強調だけ
EOF
}

function fdh() {
  cat <<EOF
$ fd .go
$ fd -t       # タイプ(f,d,l,x)を指定
$ fd -E       # 除外
$ fd -c never # 色なし
$ fd -d 1     # 深さ
$ fd -H       # hidden 含む
$ fd -x cat   # コマンド実行
EOF
}

function sdh() {
  cat <<EOF
$ sd これを これに memo.md
$ sd -F '[tag]' '[web]' memo.md # fixed string mode
$ sd '[(.*?), (.*?)]' '<$1, $2>' memo.md
EOF
}

function ghh() {
  cat <<EOF
$ gh repo clone jxck/html2json

$ gh pr list
$ gh pr checkout #xxx
$ gh pr diff #xxx
$ gh pr create #作成
EOF
}

function dusth() {
  cat <<EOF
$ dust # 表示
$ dust -X node_modules # 除外
$ dust -i              # 隠しファイル除外
$ dust -n 30           # ディレクトリ数
$ dust -d 3            # 深さ
$ dust -c              # 色なし
$ dust -p              # パスも
$ dust -e test         # 含む
$ dust -v test         # 含まない
$ dust -z 10M          # 10M 以上
EOF
}

function dufh() {
  cat <<EOF
$ duf
$ duf --all
$ duf --sort size
EOF
}

function btmh() {
  cat <<EOF
$ btm

# マウスで選んで e 押すとその widget を拡大
# process は t で tree mode
# process は dd で kill
EOF
}

function procsh() {
  cat <<EOF
$ procs
$ procs zsh
$ procs --tree
$ procs --sorta memory
$ procs --sortd memory
EOF
}

# ヘルプ関数(gith, vimh 等)の一覧を fzf で選択する
function h() {
  print -l ${(ok)functions} | rg --color never '^[^_].{0,6}h$' | fzf
}
