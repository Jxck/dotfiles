## Completion configuration
autoload -U compinit
compinit

# language configuration
export LANG=ja_JP.UTF-8

# alias
alias r="rails"
alias rs="unicorn -p 3000"

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
HISTFILE=~/dotfiles/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups  # ignore duplication command history list
setopt hist_ignore_space # ignore when commands starts with space
setopt share_history     # share command history data

# ignore
HISTIGNORE="ls:cd:pwd"
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    [[ ${cmd} != (ls|cd|pwd) ]]
}

# default Shell(zsh) => screen => zsh
if [ $SHLVL = 1 ];then
    # screen
    tmux
fi

# source nodebrew
if [[ -f ~/.nodebrew/nodebrew ]]; then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
    nodebrew use v0.6.7
fi

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    . "$HOME/.rvm/scripts/rvm"
    rvm gemset use rails31
fi

# include
[ -f ~/dotfiles/zsh/.showbranch ] && source ~/dotfiles/zsh/.showbranch
[ -f ~/dotfiles/zsh/.mac ] && source ~/dotfiles/zsh/.mac
#[ -f ~/dotfiles/zsh/.ubuntu ] && source ~/dotfiles/zsh/.ubuntu
#[ -f ~/dotfiles/zsh/.office ] && source ~/dotfiles/zsh/.office
