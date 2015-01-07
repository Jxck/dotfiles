## Completion configuration
autoload -U compinit
compinit

# language configuration
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# auto menu complete
setopt auto_menu

# auto change directory
setopt auto_cd

# use brace
setopt brace_ccl

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
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups  # ignore duplication command history list
setopt hist_ignore_space # ignore when commands starts with space
setopt share_history     # share command history data

# ignore
HISTIGNORE="ls:pwd"
zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}

  [[ ${cmd} != (ls|pwd|cd) ]]
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
if [ -f $HOME/.nodebrew/nodebrew ]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  nodebrew use v0.11
  . <(npm completion)
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
  rbenv global 2.0.0-p0
fi

if [ -d "$HOME/.gobrew" ]; then
  # prepare directories
  [ ! -d "$HOME/.gobrew/go" ] && mkdir $HOME/.gobrew/go
  [ ! -f "$HOME/.gobrew/go/current" ] && touch $HOME/.gobrew/go/current
  [ ! -d "$HOME/.gobrew/env" ] && mkdir $HOME/.gobrew/env
  [ ! -f "$HOME/.gobrew/env/.gopath" ] && touch $HOME/.gobrew/env/.gopath

  # export path
  source $HOME/.gobrew/env/.gopath
  export GOROOT=$HOME/.gobrew/go/current
  export PATH=$PATH:$GOROOT/bin
  export PATH=$HOME/.gobrew/bin:$PATH
  echo "GOPATH: $GOPATH"
fi


# export
[ -d "$HOME/.spdylay" ] && export PATH=$HOME/.spdylay/src:$PATH
[ -d "$HOME/.nghttp2" ] && export PATH=$HOME/.nghttp2/src:$PATH
[ -d "$HOME/.flow" ] && export PATH=$HOME/.flow:$PATH
[ -d "$HOME/.icdiff" ] && export PATH=$HOME/.icdiff:$PATH && alias diff=icdiff
[ -d "$HOME/.tsc/built/local" ] && export PATH=$HOME/.tsc/built/local:$PATH
[ -d "$HOME/dotfiles/bin" ] && export PATH=$HOME/dotfiles/bin:$PATH

# include
[ -f $HOME/dotfiles/zsh/.common ] && source $HOME/dotfiles/zsh/.common
[ -f $HOME/dotfiles/zsh/.peco ] && source $HOME/dotfiles/zsh/.peco
[ -f $HOME/dotfiles/zsh/.showbranch ] && source $HOME/dotfiles/zsh/.showbranch
[ -f $HOME/dotfiles/zsh/.rails_alias ] && source $HOME/dotfiles/zsh/.rails_alias
[ -f $HOME/dotfiles/zsh/.http_status ] && source $HOME/dotfiles/zsh/.http_status
[ -f $GOROOT/misc/zsh/go ] && source $GOROOT/misc/zsh/go
