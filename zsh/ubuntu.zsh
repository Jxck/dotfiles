# (Ubuntu)

# color
autoload colors
colors

# prompt user@host color
# http://qiita.com/k_ui/items/281a7b226b17800b0202
COLORS=(
  # $'%{\e[0;31m%}' # red
  # $'%{\e[0;32m%}' # green
  # $'%{\e[0;33m%}' # brown
  # $'%{\e[0;34m%}' # blue
  # $'%{\e[0;35m%}' # purple
  # $'%{\e[0;36m%}' # cyan

  ## light colors
  $'%{\e[1;31m%}' # red
  $'%{\e[1;32m%}' # green
  $'%{\e[1;33m%}' # brown
  $'%{\e[1;34m%}' # blue
  $'%{\e[1;35m%}' # purple
  $'%{\e[1;36m%}' # cyan
)

# colorize user/host with each name
if [[ "$HOST" == "jxck.io" ]]; then
  COLOR_HOST=$COLORS[2]$HOST
elif [[ "$HOST" == "jxck.dev" ]]; then
  COLOR_HOST=$COLORS[6]$HOST
elif [[ "$HOST" == "jxck.gce" ]]; then
  COLOR_HOST=$COLORS[7]$HOST
else
  COLOR_HOST=$COLORS[1]$HOST
fi
COLOR_USER=$COLORS[$((`echo "$USER" | sum | cut -f1 -d' '`%${#COLORS}))+1]$USER
COLOR_RESET="%{$reset_color%}"
COLOR_RED="%{$fg[red]%}"
COLOR_CYAN="%{$fg[cyan]%}"

# prompt configuration
PROMPT="${COLOR_USER}"${COLOR_RESET}"@${COLOR_HOST}"${COLOR_RESET}"$ "
PROMPT2="${COLOR_RED}%_> ${COLOR_RESET}"
RPROMPT='[`rprompt-git-current-branch` %~]:${COLOR_CYAN}$(tty):$(echo $$)${COLOR_RESET}'
SPROMPT="${COLOR_RED}correct?: %R -> %r [n,y,a,e]:${COLOR_RESET}"

# copy
alias pb="xsel --clipboard --input"
alias pbp="xsel --clipboard"
# TODO: fixme like mac
alias pwd="pwd | tee /dev/stderr | xsel --clipboard --input"
alias time="\time -f \"%e %C\""

alias open="xdg-open 1>/dev/null 2>/dev/null"

# time setting without ntp
function timeset() {
  sudo date -s "$(curl -s --head http://www.google.co.jp | grep ^Date | cut -b 7-)"
}

# vim
export EDITOR=vim

# less
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'

# alias
#alias lss="\ls --color=always -lah"
#alias ll="ls --color=always -lah"
#alias ls="ls -A1hv --color=always"

# show motd message
/bin/ls -1 /etc/update-motd.d | grep -v '00-header' | grep -v '10-help-text' | xargs -I{} sh /etc/update-motd.d/{}

cat /var/lib/ubuntu-release-upgrader/release-upgrade-available | xargs -I{} echo -e "\e[0;92m{}\e[m"
