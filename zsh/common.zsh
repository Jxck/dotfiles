alias -g N="1>/dev/null 2>/dev/null"
alias -g B="1>/dev/null 2>/dev/null &"
alias re="exec $SHELL"
alias rmf="\rm -rf"
alias vag="vagrant"
alias t="npm t"

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

function wsecho() {
  $(websocketd --port $1 echo.rb)
}

# emptify file
function empty() {
  sudo cp /dev/null $1
}

# current time
function now() {
  UNIXTIME=$(curl -s "http://www.convert-unix-time.com/api?timestamp=now&timezone=tokyo" | jq .timestamp)
  date -r $UNIXTIME +%Y/%m/%d\(%a\)\ %H:%M
}

# upload file
function up() {
  scp $1 jxck@jxck.io:src/files/tmp
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

# cd with adding full path to history
function cd() {
  p=$@                   # current arg
  if [[ $p = "" ]]; then # cd only
    p=$HOME              # path to home
  fi
  p=${p:a}               # expand to full path
  print -s cd $p         # add history
  builtin cd $p          # exec original cd
  return $?
}

# show $PATH in each line
function path() {
  LF=$(printf '\\\012_')
  LF=${LF%_}

  echo $PATH | sed 's/:/'"$LF"'/g'
}

# show proxy settings
function proxy() {
  printenv | grep -i "proxy\|socks" | sort | sed 's/=/\t/'
}
