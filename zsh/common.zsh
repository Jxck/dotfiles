alias -g N="1>/dev/null 2>/dev/null" # No Output
alias -g B="1>/dev/null 2>/dev/null &" # Back
alias -g A="2>&1" # All
alias -g C="2>&1 | color" # Color
alias -g H="| xxd -g 1 -c 4" # Hex
alias -g V="2>&1 | vim -c 'au! CursorHold' -" # open stdout with vim
alias -g PP="|&pp" # golang panicparse
alias -g U="| sort | uniq -c | sort -nr"

alias ls="l"
alias ll="l -ah"
alias lls="l -a"

alias grep="grep --col"
alias emacs="emacs -nw"
alias tree="tree --charset unicode -L 3"
alias re="exec $SHELL"
alias rmf="\rm -rf"
alias vag="vagrant"
alias cdd="cd $DOTFILES"

# jxck.io
alias blog="cd $SERVER/jxck.io/blog.jxck.io"
alias labs="cd $SERVER/jxck.io/labs.jxck.io"
alias log="cd $SERVER/logs"
alias db="cd $SERVER/db"

# less
export LESS='-gj10R'
export LESS_TERMCAP_so=$'\E[01;33;03;40m'

# show git FAQ command
function gith() {
  cat <<EOF
[push branch] $ git push origin dev
[ck branch]   $ git checkout -b dev origin/dev
[del branch]  $ git push origin :dev
[sync branch] $ git fetch --prune
[pull force]  $ git fetch --all && git reset --hard origin/master
[clone submod]$ git submodule init && git submodule update
[up submod]   $ git submodule foreach 'git pull origin master'
[patch]       $ git diff --no-prefix HEAD~ > my.patch
[apply]       $ patch -p0 < my.patch
EOF
}

# show grep FAQ command
function greph() {
  cat <<EOF
[ignore]  $ grep -v
[only]    $ grep -o
[exclude] $ grep --exclude-dir=pkg
[no name] $ grep -h
EOF
}

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

# emptify file
function empty() {
  cp /dev/null $1
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

function diffp() {
  diff <(cat $1) <(pbp)
}

# alc for CLI
function alc() {
  if [ $# != 0 ]; then
    w3m "http://eow.alc.co.jp/$*/UTF-8/?ref=sa" | less +30
  else
    echo 'usage: alc word'
  fi
}

# coloring file
function cat() {
  if [ $# -ge 2 ]; then
    if [ $2 == "-c" ]; then
      source-highlight --failsafe --infer-lang -f esc -o STDOUT -i $1
    else
      /bin/cat $*
    fi
  else
    /bin/cat $*
  fi
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
