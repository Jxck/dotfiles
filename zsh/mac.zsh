# zsh for Mac

# color
autoload -U colors
colors

# prompt user@host color
COLOR_USER="%{$fg_bold[blue]%}"
COLOR_RESET="%{$reset_color%}"
COLOR_RED="%{$fg[red]%}"
COLOR_CYAN="%{$fg[cyan]%}"
COLOR_PID="%{$fg[blue]%}"

# prompt configuration
PROMPT="${COLOR_USER}%n${COLOR_RESET}$ "
PROMPT2="${COLOR_RED}%_> ${COLOR_RESET}"
RPROMPT='[`rprompt-git-current-branch` %~]:${COLOR_CYAN}$(tty):$(echo $$)${COLOR_RESET}'
SPROMPT="${COLOR_RED}correct?: %R -> %r [n,y,a,e]:${COLOR_RESET}"

# copy
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
export EDITOR=/usr/bin/vim #/usr/local/bin/vim #/Applications/MacVim.app/Contents/MacOS/Vim
alias vim='env LANG=ja_JP.UTF-8 $EDITOR "$@"'

# alias
alias pwd="pwd | tee >(pbcopy)"
alias google_chrome="open -a Google\ Chrome"
alias edge="open -a Microsoft\ Edge"
alias code="open -a Visual\ Studio\ Code"
alias time='gtime -f "%e %C"'
