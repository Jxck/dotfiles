## (Mac)

# prompt configuration
PROMPT="%n$ "
SPROMPT="%r is correct? [n,y,a,e]: "

# COPY
alias pbp="pbpaste"

#alias pb="pbcopy"
function pb() {
  if [ -t 0 ]; then
    cat $1 | pbcopy
  else
    pbcopy < /dev/stdin
  fi
}

# time setting without ntp
function timeset() {
  UNIXTIME=$(curl -s "http://www.convert-unix-time.com/api?timestamp=now&timezone=tokyo" | jq .timestamp)
  fmttime=$(date -r $UNIXTIME +%m%d%H%M%y)
  sudo date $fmttime
}

# vim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vim='env LANG=ja_JP.UTF-8 $EDITOR "$@"'

# alias
#alias lss="\ls -lahG"
#alias ll="ls -lahG"
#alias ls="ls -A1hvG"
alias rm="rmtrash"
alias pwd="pwd | tee >(pbcopy)"
alias google_chrome="open -a Google\ Chrome"
