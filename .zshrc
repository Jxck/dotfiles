## Completion configuration
autoload -U compinit
compinit

# language configuration
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

# command correct edition before each completion attempt
# setopt correct

# compacked complete list display
setopt list_packed

# no beep sound when complete list displayed
setopt nolistbeep

# emacs like keybind (e.x. Ctrl-a, Ctrl-e
bindkey -e

# predict
# autoload predict-on
# predict-on

setopt multios

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## Command history configuration
HISTFILE=$HOME/dotfiles/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups  # ignore duplication command history list
setopt hist_ignore_space # ignore when commands starts with space
setopt share_history     # share command history data

# ignore
HISTIGNORE="ls:pwd"
zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}

  [[ ${cmd} != (ls|pwd) ]]
}

# default Shell(zsh) => tmux => zsh
if [ $SHLVL = 1 ]; then
  # reattach-to-user-namespace when mac
  if [ `uname` = "Darwin" ]; then
    tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
    tmux -f <(echo "$tmux_config")
  else
    tmux
  fi
fi

if [ `uname` = "Darwin" ]; then
  [ -f $HOME/dotfiles/zsh/.mac ] && source $HOME/dotfiles/zsh/.mac
elif [ `uname` = "Linux" ]; then
  [ -f $HOME/dotfiles/zsh/.ubuntu ] && source $HOME/dotfiles/zsh/.ubuntu
fi

# source nodebrew
if [[ -f $HOME/.nodebrew/nodebrew ]]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  nodebrew use v0.10
  . <(npm completion)
fi

if [[ -s "$HOME/.rbenv/bin" ]]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
  rbenv global 2.0.0-p0
fi

if [[ -s "$HOME/.gobrew" ]]; then
  if [[ ! -s "$HOME/.gobrew/go" ]]; then
    mkdir $HOME/.gobrew/go
  fi
  if [[ ! -s "$HOME/.gobrew/go/current" ]]; then
    touch $HOME/.gobrew/go/current
  fi
  if [[ ! -s "$HOME/.gobrew/env" ]]; then
    mkdir $HOME/.gobrew/env
  fi
  if [[ ! -s "$HOME/.gobrew/env/.gopath" ]]; then
    touch $HOME/.gobrew/env/.gopath
  fi
  source $HOME/.gobrew/env/.gopath

  export GOROOT=$HOME/.gobrew/go/current
  export PATH=$PATH:$GOROOT/bin
  export PATH=$HOME/.gobrew/bin:$PATH
  echo "GOPATH: $GOPATH"
fi

if [[ -s "$HOME/.spdylay" ]]; then
  export PATH=$HOME/.spdylay/src:$PATH
fi

if [[ -s "$HOME/.nghttp2" ]]; then
  export PATH=$HOME/.nghttp2/src:$PATH
fi

if [[ -s "$HOME/dotfiles/bin" ]]; then
  export PATH=$HOME/dotfiles/bin:$PATH
fi

# include
[ -f $HOME/dotfiles/zsh/.common ] && source $HOME/dotfiles/zsh/.common
[ -f $HOME/dotfiles/zsh/.peco ] && source $HOME/dotfiles/zsh/.peco
[ -f $HOME/dotfiles/zsh/.showbranch ] && source $HOME/dotfiles/zsh/.showbranch
[ -f $HOME/dotfiles/zsh/.rails-alias ] && source $HOME/dotfiles/zsh/.rails-alias
[ -f $GOROOT/misc/zsh/go ] && source $GOROOT/misc/zsh/go

# Heroku Toolbelt
[ -f /usr/local/heroku/bin ] && export PATH="/usr/local/heroku/bin:$PATH"
