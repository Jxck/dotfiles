function tmux_h() {
  cat <<EOF
C-s C-o  # swap pane
EOF
}

function zsh_h() {
  cat <<EOF
alias -g N="1>/dev/null 2>/dev/null"          # No Output
alias -g B="1>/dev/null 2>/dev/null &"        # Background
alias -g A="2>&1"                             # All (merge stdout/err)
alias -g C="2>&1 | color"                     # Color (All then colorize)
alias -g H="| xxd -g 1 -c 4"                  # Hex
alias -g V="2>&1 | vim -c 'au! CursorHold' -" # Vim from stdout
alias -g PP="|&pp"                            # PanicParse (golang)
alias -g S="| less -S"                        # Shorten long lines
alias -g T="| tee -a /dev/stderr"             # Tee to stderr
alias -g U="| sort | uniq -c | sort -nr"      # Count
alias -g W="| btee"                           # Window in browser
EOF
}

function less_h() {
  cat <<EOF
[line count] $ less -M
[show ansi]  $ less -R
[nowrap]     $ less -S
[tail -f]    $ Shift+F
[grep]       $ &word
[grep -v]    $ &!word
EOF
}

function git_h() {
  cat <<EOF
[push branch]  $ git push origin dev
[ck branch]    $ git checkout -b dev origin/dev
[del branch]   $ git push origin :dev
[sync branch]  $ git fetch --prune
[pull force]   $ git fetch --all && git reset --hard origin/master
[clone submod] $ git submodule init && git submodule update
[up submod]    $ git submodule foreach 'git pull origin master'
[patch]        $ git diff --no-prefix HEAD~ > my.patch
[apply]        $ patch -p0 < my.patch
[reset atime]  $ $DOTFILES/bin/git-touch.sh
[shallow]      $ git clone --depth 1 https://github.com/git/git
EOF
}

function grep_h() {
  cat <<EOF
[ignore]  $ grep -v
[only]    $ grep -o
[exclude] $ grep --exclude-dir=pkg
[no name] $ grep -h
[unicode] $ grep "$(printf '\uFE0F')" ./**/*.html
EOF
}

function sed_h() {
  cat <<EOF
[infile]  $ sed -i
[regexp]  $ sed -r
[replace] $ sed -ir 's/a/A/g' ./**/*.html
EOF
}

function find_h() {
  cat <<EOF
[name] $ find ./ -name *.md
[each] $ find ./ -name *.md | xargs -L 1 echo
EOF
}

function docker_h() {
  cat <<EOF
[build]     $ docker build -t name/image:1.1 .
[run]       $ docker run -d -p 3000:80 name/image:2.0
[nsenter]   $ docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
[enter]     $ docker-enter PID
EOF
}

function vim_h() {
  cat <<EOF
Window
[window rotate] <ctl-w> r
[window move]   <ctl-w> [k/j/h/l]
[to horizonal]  <ctl-w> K
[to vertical]   <ctl-w> H

Tab
[tab open]  <ctl-t><ctl-o>
[tab close] <ctl-t><ctl-c>
[tab next]  <ctl-t><ctl-n>
[tab prev]  <ctl-t><ctl-p>

CLI
$ vim +command +qall
$ vim -c 'Command' -c 'qa!'
EOF
}

function curl_h() {
  cat <<EOF
[show header]  --include
[ignore cert]  --insecure
[post]         -X POST -d 'aaa=bbb&ccc=ddd'
[post JSON]    -X POST -H "Content-Type: application/json" -d 'aaa=bbb&ccc=ddd'
EOF
}

function chrome_h() {
  cat <<EOF
$ git rebase-update
$ gclient sync
$ git checkout -b feature-2222222
$ git cl patch 2222222
$ autoninja -C out/Default chrome
EOF
}

function rg_h() {
  cat <<EOF
$ rg test      # ディレクトリ内で再起検索
$ rg -i wod    # 大文字小文字無視
$ rg -w word   # 単語検索
$ rg -e word   # 強調だけ
EOF
}

function fd_h() {
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

function sd_h() {
  cat <<EOF
$ sd これを これに memo.md
$ sd -s '[tag]' '[web]' memo.md # string mode
$ sd '[(.*?), (.*?)]' '<$1, $2>' memo.md
EOF
}

function gh_h() {
  cat <<EOF
$ gh repo clone jxck/html2json

$ gh pr list
$ gh pr checkout #xxx
$ gh pr diff #xxx
$ gh pr create #作成
EOF
}

function dust_h() {
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

function duf_h() {
  cat <<EOF
$ duf
$ duf --all
$ duf --sort size
EOF
}

function btm_h() {
  cat <<EOF
$ btm

# マウスで選んで e 押すとその widget を拡大
# process は t で tree mode
# procees は dd で kill
EOF
}

function procs_h() {
  cat <<EOF
$ procs
$ procs zsh
$ procs --tree
$ procs --sorta memory
$ procs --sortd memory
EOF
}

function h() {
  print -l ${(ok)functions} | rg --color never '_h$' | peco
}
