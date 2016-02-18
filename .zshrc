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

# compacked complete list display
setopt list_packed

# no beep sound when complete list displayed
setopt nolistbeep

# no no match found
setopt nonomatch

# emacs like keybind (e.x. Ctrl-a, Ctrl-e)
bindkey -e

# multi redirect (e.x. echo "hello" > hoge1.txt > hoge2.txt)
setopt multios

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## export original variable
export DOTFILES=$HOME/dotfiles

## Command history configuration
HISTFILE=$HOME/.zsh_history
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

    # try attache tmux when connect via ssh
    if [ "${SSH_CONNECTION-}" = "" ]; then
      tmux -f <(echo "$tmux_config")
    else
      tmux a || tmux -f <(echo "$tmux_config")
    fi
  else
    # try attache tmux when connect via ssh
    if [ "${SSH_CONNECTION-}" = "" ]; then
      tmux
    else
      tmux a || tmux
    fi
  fi
fi

# source nodebrew
if [ -f $DOTFILES/pkg/nodebrew/nodebrew ]; then
  export NODEBREW_ROOT=$DOTFILES/pkg/nodebrew
  export PATH=$NODEBREW_ROOT/current/bin:$PATH
  nodebrew use v4
  . <(npm completion)
  alias npmls="npm ls --depth 0"

  # always add path of current repo
  export PATH=./node_modules/.bin:$PATH
fi

if [ -d "$DOTFILES/pkg/rbenv/bin" ]; then
  export RBENV_ROOT=$DOTFILES/pkg/rbenv
  export PATH=$RBENV_ROOT/bin:$PATH
  eval "$(rbenv init -)"
  rbenv global 2.2.3
fi

if [ -d "$DOTFILES/bin/.gobrew" ]; then
  # prepare directories
  [ ! -d "$DOTFILES/bin/.gobrew/go" ] && mkdir $DOTFILES/bin/.gobrew/go
  [ ! -f "$DOTFILES/bin/.gobrew/go/current" ] && touch $DOTFILES/bin/.gobrew/go/current
  [ ! -d "$DOTFILES/bin/.gobrew/env" ] && mkdir $DOTFILES/bin/.gobrew/env
  [ ! -f "$DOTFILES/bin/.gobrew/env/.gopath" ] && touch $DOTFILES/bin/.gobrew/env/.gopath

  # export path
  source $DOTFILES/bin/.gobrew/env/.gopath
  export GOROOT=$DOTFILES/bin/.gobrew/go/current
  export PATH=$GOROOT/bin:$PATH
  export PATH=$DOTFILES/bin/.gobrew/bin:$PATH
  echo "GOPATH: $GOPATH"
fi

# export
[ -d "$DOTFILES/pkg/nghttp2" ] && export PATH=$DOTFILES/pkg/nghttp2/src:$PATH
[ -d "$DOTFILES/pkg/icdiff" ] && export PATH=$DOTFILES/pkg/icdiff:$PATH && alias diff=icdiff
[ -d "$DOTFILES/pkg/peco" ] && export PATH=$DOTFILES/pkg/peco:$PATH
[ -d "$DOTFILES/pkg/websocketd" ] && export PATH=$DOTFILES/pkg/websocketd:$PATH
[ -d "$DOTFILES/pkg/weighttp" ] && export PATH=$DOTFILES/pkg/weighttp/build/default:$PATH
[ -d "$DOTFILES/bin" ] && export PATH=$DOTFILES/bin:$PATH

# include
if [ `uname` = "Darwin" ]; then
  [ -f $DOTFILES/zsh/mac.zsh ] && source $DOTFILES/zsh/mac.zsh
elif [ `uname` = "Linux" ]; then
  [ -f $DOTFILES/zsh/ubuntu.zsh ] && source $DOTFILES/zsh/ubuntu.zsh
fi

[ -f $DOTFILES/zsh/common.zsh ] && source $DOTFILES/zsh/common.zsh
[ -f $DOTFILES/zsh/peco.zsh ] && source $DOTFILES/zsh/peco.zsh
[ -f $DOTFILES/zsh/showbranch.zsh ] && source $DOTFILES/zsh/showbranch.zsh
[ -f $DOTFILES/zsh/rails_alias.zsh ] && source $DOTFILES/zsh/rails_alias.zsh
[ -f $DOTFILES/zsh/http_status_codes.zsh ] && source $DOTFILES/zsh/http_status_codes.zsh
