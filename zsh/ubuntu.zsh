# (Ubuntu)

# color
autoload colors
colors

# prompt user@host color
# http://qiita.com/k_ui/items/281a7b226b17800b0202
colors=(
  $'%{\e[0;31m%}' # red
  $'%{\e[0;32m%}' # green
  $'%{\e[0;33m%}' # brown
  $'%{\e[0;34m%}' # blue
  $'%{\e[0;35m%}' # purple
  $'%{\e[0;36m%}' # cyan

  ## light colors
  $'%{\e[1;31m%}' # red
  $'%{\e[1;32m%}' # green
  $'%{\e[1;33m%}' # brown
  $'%{\e[1;34m%}' # blue
  $'%{\e[1;35m%}' # purple
  $'%{\e[1;36m%}' # cyan
)

colored_user=$colors[$((`echo "$USER" | sum | cut -f1 -d' '`%${#colors}))+1]$USER
colored_host=$colors[$((`echo "$HOST" | sum | cut -f1 -d' '`%${#colors}))+1]$HOST

# prompt configuration
PROMPT="$colored_user"$'%{\e[1;39m%}'"@$colored_host"$'%{\e[1;39m%}'"$ "
PROMPT2="%{${fg[red]}%}%_> %{${reset_color}%}"
RPROMPT="%{${fg[cyan]}%}[%~]%{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct?: %R -> %r [n,y,a,e]:%{${reset_color}%}"

# copy
alias pb="xsel --clipboard --input"
alias pbp="xsel --clipboard"
# TODO: fixme like mac
alias pwd="pwd | tee /dev/stderr | xsel --clipboard --input"

# time setting without ntp
function timeset() {
  sudo date -s "$(curl -s --head http://www.google.co.jp | grep ^Date | cut -b 7-)"
}

# vim
export EDITOR=vim

# alias
#alias lss="\ls --color=always -lah"
#alias ll="ls --color=always -lah"
#alias ls="ls -A1hv --color=always"
