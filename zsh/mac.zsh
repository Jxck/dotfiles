## (Mac)

# prompt configuration
PROMPT="%n$ "
#RPROMPT="[%/]"
SPROMPT="%r is correct? [n,y,a,e]: "

# ls color
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=33:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# pb
#alias pbp="pbpaste"
function pbp() {
  pbpaste | sed '
    s/”/"/g
    s/“/"/g
    s/–/-/g
  ' | sed "s/’/'/g"
}

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

# alias
alias ls="ls -A1hvG"
alias ll="ls -lahG"
alias grep="grep --col"
alias rm="rmtrash"

alias pwd="pwd | tee >(pbcopy)"
alias sf="TZ=America/Los_Angeles date"

alias google_chrome="open -a Google\ Chrome"

# vim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

# emacs
alias emacs="emacs -nw"
