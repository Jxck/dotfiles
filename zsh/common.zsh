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
alias -g W="2>&1 | btee"                      # Window in browser

alias ls="l"
alias ll="l -ah"
alias lls="l -a"

# alias xargs="xargs --no-run-if-empty -L 1"
alias grep="grep --col"
alias emacs="emacs -nw"
alias tree="tree --charset unicode -L 3"
alias re="stty sane && exec $SHELL" # 特殊文字を戻す
alias rm="rmm"
alias vag="vagrant"
alias tailf="tail -f"
alias les="less"
alias ssh="ssh -XC"
alias core="nproc"
alias cdd="cd $DOTFILES"

# jxck.io
alias cdj="cd $SERVER/jxck.io"
alias blog="cd $SERVER/jxck.io/blog.jxck.io"
alias draft="cd $SERVER/jxck.io/blog.jxck.io/drafts"
alias labs="cd $SERVER/jxck.io/labs.jxck.io"
alias logs="cd $SERVER/jxck.io/logs.jxck.io"

# web-anatomia
alias cdw="cd $HOME/develop/web-anatomia"

# less
export LESS='--no-init --raw-control-chars'
# export LESSOPEN in ubuntu.zsh/mac.zsh
export MANPAGER='less'
unset LESS_TERMCAP_so
man() {
  # mb=ブリンクモード開始
  # md=ダブルブライトモード開始
  # me=装飾モード終了
  # se=強調終了
  # so=強調開始
  # ue=下線終了
  # us=下線開始
  # http://www.gnu.org/software/termutils/manual/termcap-1.3/html_mono/termcap.html#SEC44
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;35m")    \
    LESS_TERMCAP_md=$(printf "\e[1;36m")    \
    LESS_TERMCAP_me=$(printf "\e[0m")       \
    LESS_TERMCAP_se=$(printf "\e[0m")       \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m")       \
    LESS_TERMCAP_us=$(printf "\e[1;32m")    \
    man "$@"
}

# show tmux aliased command
function tmuxh() {
  cat <<EOF
C-s C-o  # swap pane
EOF
}

# show zsh aliased command
function zshh() {
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

# show less FAQ command
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

# show git FAQ command
function gith() {
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
EOF
}

# show grep FAQ command
function greph() {
  cat <<EOF
[ignore]  $ grep -v
[only]    $ grep -o
[exclude] $ grep --exclude-dir=pkg
[no name] $ grep -h
[unicode] $ grep "$(printf '\uFE0F')" ./**/*.html
EOF
}

# show sed FAQ command
function sedh() {
  cat <<EOF
[infile]  $ sed -i
[regexp]  $ sed -r
[replace] $ sed -ir 's/a/A/g' ./**/*.html
EOF
}

# show find FAQ command
function findh() {
  cat <<EOF
[name] $ find ./ -name *.md
[each] $ find ./ -name *.md | xargs -L 1 echo
EOF
}

# show docker FAQ command
function dockerh() {
  cat <<EOF
[build]     $ docker build -t name/image:1.1 .
[run]       $ docker run -d -p 3000:80 name/image:2.0
[nsenter]   $ docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
[enter]     $ docker-enter PID
EOF
}

# show rbenv FAQ command
function rbenvh() {
  cat <<EOF
[gem]       $ rbenv exec gem install bundler
[init]      $ bundle init
[install]   $ bundle install --path vendor/bundle
[rails]     $ bundle exec rails new example --skip-bundle
EOF
}

function vimh() {
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

# emptify file
function empty() {
  cp /dev/null $1 2>/dev/null || sudo cp /dev/null $1
}

# current time
function now() {
  UNIXTIME=$(curl -s "http://www.convert-unix-time.com/api?timestamp=now&timezone=tokyo" | jq .timestamp)
  date -r $UNIXTIME +%Y/%m/%d\(%a\)\ %H:%M
}

# upload file
function up() {
  scp $1 jxck@jxck.io:server/files.jxck.io/tmp
}

# show port of process
function port() {
  PID=$(lsof -i:$1 | awk 'NR>=2 {print $2}' | sort | uniq)
  if [[ $2  = "-k" ]]; then
    kill -9 $PID
  else
    echo $PID
  fi
}

# show $PATH in each line
function path() {
  LF=$(printf '\\\012_')
  LF=${LF%_}

  echo $PATH | sed 's/:/'"$LF"'/g'
}

# show proxy settings
function proxy() {
  printenv | grep -i "proxy\|socks" | sort -f | sed "s/=/$(printf '\t')/"
}

# diff with clipboard
function diffp() {
  diff <(cat $1) <(pbp)
}

# mkdir then cd
function mkdir() {
  /bin/mkdir $1
  cd $1
}

# alc for CLI
function alc() {
  if [ $# != 0 ]; then
    w3m "http://eow.alc.co.jp/$*/UTF-8/?ref=sa" | less +30
  else
    echo 'usage: alc word'
  fi
}

# coloring file with cat
#function cat() {
#  if [ $# -ge 2 ]; then
#    if [ $2 == "-c" ]; then
#      source-highlight --failsafe --infer-lang -f esc -o STDOUT -i $1
#    else
#      /bin/cat $*
#    fi
#  else
#    /bin/cat $*
#  fi
#}

# pcap2text
function pcap2text() {
  tshark -x -r $1 | cut -d' ' -f1-18 > ${1:s/.pcapng/.txt}
}

# lint as filetype
function lint() {
  if [ $# == 0 ]; then
    cat <<EOF
$ lint foo.js  # eslint
$ lint bar.md  # textlint
$ lint bar.txt # textlint
EOF
    return
  fi

  FILEPATH=$1
  EXTNAME=${FILEPATH##*.}

  if [ $EXTNAME == "js" ]; then
    eslint -c $DOTFILES/misc/.eslintrc $1
    return
  fi

  if [ $EXTNAME == "rb" ]; then
    rubocop -c $DOTFILES/misc/.rubocop.yml $1
    return
  fi

  if [ $EXTNAME == "md" -o $EXTNAME == "txt" ]; then
    textlint -c $DOTFILES/misc/.textlintrc $1
    return
  fi
}
