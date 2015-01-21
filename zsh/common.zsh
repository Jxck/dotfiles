alias -g N="1>/dev/null 2>/dev/null"
alias -g B="1>/dev/null 2>/dev/null &"
alias re="exec $SHELL"
alias rmf="\rm -rf"
alias vag="vagrant"

# show git FAQ command
function gith() {
  cat <<EOF
[push branch] $ git push origin dev
[ck branch]   $ git checkout -b dev origin/dev
[del branch]  $ git push origin :dev
[sync branch] $ git fetch --prune
[pull force]  $ git fetch --all && git reset --hard origin/master
[up submod]   $ git submodule foreach 'git pull origin master'
EOF
}

# emptify file
function empty() {
  sudo cp /dev/null $1
}

# time setting without ntp
function timeset() {
  sudo date -s "$(curl -s --head http://www.google.co.jp | grep ^Date | cut -b 7-)"
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
