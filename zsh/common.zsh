alias -g N="1>/dev/null 2>/dev/null"          # No Output
alias -g B="1>/dev/null 2>/dev/null &"        # Background
alias -g A="2>&1"                             # All (merge stdout/err)
alias -g C="2>&1 | color"                     # Color (All then colorize)
alias -g H="| xxd -g 1 -c 4"                  # Hex
alias -g V="2>&1 | vim -c 'au! CursorHold' -" # Vim from stdout
alias -g PP="|&pp"                            # PanicParse (golang)
#alias -g S="| less -S"                       # Shorten long lines
alias -g T="| tee -a /dev/stderr"             # Tee to stderr
alias -g S="| sort | uniq"                    # Sort
alias -g U="| sort | uniq -c | sort -nr"      # Count
alias -g UU="| sort | uniq -c | sort -n | sed -E 's/^ +[0-9]+ //g'" # No Number
alias -g W="2>&1 | btee"                      # Window in browser
alias -g L="| awk '{ print length, \$0 }' | sort -n | uniq | cut -d' ' -f2" # Sort by Length
alias -g LL="| length-count-sort.rb "         # Sort by Length

alias ls="l"
alias ll="l -ah"
alias lls="l -a"
alias du="du -hc -d 1"

alias grep="grep --col -E"
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
alias diff="icdiff"

# replace
alias   df="echo use duf instead"
alias   du="echo use dust instead"
alias find="echo use fd instead"
alias   ps="echo use procs instead"
alias  sed="echo use sd instead"
alias grep="echo use ripgrep instead"

# git
alias f="git f"
alias st="git st"

# sudo with current env
alias sudoo="sudo -E env PATH=$PATH"

# jxck.io
alias cdj="cd   $DEV/jxck.io"
alias blog="cd  $DEV/jxck.io/blog.jxck.io"
alias draft="cd $DEV/jxck.io/blog.jxck.io/drafts"
alias labs="cd  $DEV/jxck.io/labs.jxck.io"
alias logs="cd  $DEV/jxck.io/logs.jxck.io"
alias cdw="cd   $DEV/web-anatomia"
alias fmt="markdown"

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

# emptify file
function empty() {
  cp /dev/null $1 2>/dev/null || sudo cp /dev/null $1
}

# current time
function now() {
  #UNIXTIME=$(curl -s "http://www.convert-unix-time.com/api?timestamp=now&timezone=tokyo" | jq .timestamp)
  #date -r $UNIXTIME +%Y/%m/%d\(%a\)\ %H:%M
  date +%Y/%m/%d\(%a\)\ %H:%M
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
  echo $PATH | sd ":" "\n"
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
  if [[ $# != 0 ]]; then
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
  if [[ $# == 0 ]]; then
    cat <<EOF
$ lint foo.js  # eslint
$ lint bar.md  # textlint
$ lint bar.txt # textlint
EOF
    return
  fi

  FILEPATH=$1
  EXTNAME=${FILEPATH##*.}

  if [[ $EXTNAME == "js" ]]; then
    eslint -c $DOTFILES/misc/.eslintrc $1
    return
  fi

  if [[ $EXTNAME == "rb" ]]; then
    rubocop -c $DOTFILES/misc/.rubocop.yml $1
    return
  fi

  if [[ $EXTNAME == "md" || $EXTNAME == "txt" ]]; then
    textlint -c $DOTFILES/misc/.textlintrc $1
    return
  fi
}
