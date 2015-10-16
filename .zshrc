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

# editor
export EDITOR=vim

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

# source nodebrew
if [ -f $HOME/.nodebrew/nodebrew ]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  nodebrew use v4
  . <(npm completion)
  alias npmls="npm ls --depth 0"
  export PATH=./node_modules/.bin:$PATH
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
  rbenv global 2.2.3
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
  export PATH=$GOROOT/bin:$PATH
  export PATH=$HOME/.gobrew/bin:$PATH
  echo "GOPATH: $GOPATH"
fi

# export
[ -d "$HOME/.spdylay" ] && export PATH=$HOME/.spdylay/src:$PATH
[ -d "$HOME/.nghttp2" ] && export PATH=$HOME/.nghttp2/src:$PATH
[ -d "$HOME/.flow" ] && export PATH=$HOME/.flow:$PATH
[ -d "$HOME/.icdiff" ] && export PATH=$HOME/.icdiff:$PATH && alias diff=icdiff
[ -d "$HOME/dotfiles/bin" ] && export PATH=$HOME/dotfiles/bin:$PATH

# include
if [ `uname` = "Darwin" ]; then
  [ -f $HOME/dotfiles/zsh/mac.zsh ] && source $HOME/dotfiles/zsh/mac.zsh
elif [ `uname` = "Linux" ]; then
  [ -f $HOME/dotfiles/zsh/ubuntu.zsh ] && source $HOME/dotfiles/zsh/ubuntu.zsh
fi

[ -f $HOME/dotfiles/zsh/common.zsh ] && source $HOME/dotfiles/zsh/common.zsh
[ -f $HOME/dotfiles/zsh/peco.zsh ] && source $HOME/dotfiles/zsh/peco.zsh
[ -f $HOME/dotfiles/zsh/showbranch.zsh ] && source $HOME/dotfiles/zsh/showbranch.zsh
[ -f $HOME/dotfiles/zsh/rails_alias.zsh ] && source $HOME/dotfiles/zsh/rails_alias.zsh
[ -f $HOME/dotfiles/zsh/http_status_codes.zsh ] && source $HOME/dotfiles/zsh/http_status_codes.zsh
