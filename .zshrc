## Completion configuration
autoload -U compinit
compinit

# remove duplicate PATH
typeset -U path PATH

# complete path when aliased command
setopt complete_aliases

# language configuration
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# auto time after REPORTTIME sec
export REPORTTIME=1

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

# disable stty stop
stty stop undef

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ignore failed command to add history
# zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

## export original variable
export DOTFILES=$HOME/dotfiles

## command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups  # ignore duplication command history list
setopt hist_ignore_space # ignore when commands starts with space
setopt share_history     # share command history data

# export
function addToPath {
  PATH="$1:$PATH"
}

# brew shellenv again
if [[ -x "$(command -v brew)" ]]; then
  eval "$(brew shellenv)"
  export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# replace BSD commands with GNU commands
addToPath $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
addToPath $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
addToPath $HOMEBREW_PREFIX/opt/diffutils/bin
addToPath $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
addToPath $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
addToPath $HOMEBREW_PREFIX/opt/gnu-time/libexec/gnubin
addToPath $HOMEBREW_PREFIX/opt/grep/libexec/gnubin

# ruby managed by brew not mise
addToPath $HOMEBREW_PREFIX/opt/ruby/bin

[[ -d "$DOTFILES/bin"                  ]] && addToPath $DOTFILES/bin
[[ -d "$DOTFILES/local/openssl/bin"    ]] && addToPath $DOTFILES/local/openssl/bin
[[ -d "$DOTFILES/local/websocketd"     ]] && addToPath $DOTFILES/local/websocketd
[[ -d "$DOTFILES/local/weighttp"       ]] && addToPath $DOTFILES/local/weighttp/bin
[[ -d "$DOTFILES/local/libsrtp/test"   ]] && addToPath $DOTFILES/local/libsrtp/test
[[ -d "$DOTFILES/local/rebar3"         ]] && addToPath $DOTFILES/local/rebar3
[[ -d "$DOTFILES/local/depot_tools"    ]] && addToPath $DOTFILES/local/depot_tools
[[ -d "$DOTFILES/local/bazel"          ]] && addToPath $DOTFILES/local/bazel/bin
[[ -d "$DOTFILES/pkg/nghttp2"          ]] && addToPath $DOTFILES/pkg/nghttp2/src
[[ -d "$DOTFILES/pkg/shared-brotli"    ]] && addToPath $DOTFILES/pkg/shared-brotli/brotli/research/bazel-bin
[[ -d "$DOTFILES/pkg/shared-brotli"    ]] && addToPath $DOTFILES/pkg/shared-brotli/brotli/bazel-bin

## node_modules bin
addToPath $DOTFILES/node_modules/.bin
addToPath ./node_modules/.bin

## diff-highlight
[[ -d "$HOMEBREW_PREFIX/share/git-core/contrib/diff-highlight" ]] && addToPath $HOMEBREW_PREFIX/share/git-core/contrib/diff-highlight
[[ -d "/usr/share/doc/git/contrib/diff-highlight" ]] && addToPath /usr/share/doc/git/contrib/diff-highlight

## iterm2_shell_integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# browser ssl master secret
# export SSLKEYLOGFILE=~/SSLKEYLOGFILE.log

# 1Password
if [[ -x "$(command -v op)" ]]; then
  eval "$(op completion zsh)"; compdef _op op
fi

# include
[[ `uname` == "Darwin" && -f $DOTFILES/zsh/mac.zsh    ]] && source $DOTFILES/zsh/mac.zsh
[[ `uname` == "Linux"  && -f $DOTFILES/zsh/ubuntu.zsh ]] && source $DOTFILES/zsh/ubuntu.zsh

[[ -f $DOTFILES/zsh/common.zsh            ]] && source $DOTFILES/zsh/common.zsh
[[ -f $DOTFILES/zsh/help.zsh              ]] && source $DOTFILES/zsh/help.zsh
[[ -f $DOTFILES/zsh/peco.zsh              ]] && source $DOTFILES/zsh/peco.zsh
[[ -f $DOTFILES/zsh/showbranch.zsh        ]] && source $DOTFILES/zsh/showbranch.zsh
[[ -f $DOTFILES/zsh/rails_alias.zsh       ]] && source $DOTFILES/zsh/rails_alias.zsh
[[ -f $DOTFILES/zsh/http_status_codes.zsh ]] && source $DOTFILES/zsh/http_status_codes.zsh


# pnpm
if [[ -d "$HOME/Library/pnpm" ]]; then
  export PNPM_HOME=$HOME/Library/pnpm
  addToPath $PNPM_HOME
fi

# mise
if type mise >/dev/null; then
  eval "$(mise activate zsh)"
  source $DOTFILES/zsh/mise.completion.zsh
  export MISE_GLOBAL_CONFIG_FILE=$DOTFILES/.mise.toml
  #export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc --disable-install-capi"
fi

# cargo (TODO: move to $DOTFILES)
if [[ -d "$HOME/.cargo" ]]; then
  addToPath $HOME/.cargo/bin
  export CARGO_NAME=Jxck
  export CARGO_EMAIL=''
  # echo "Cargo: $HOME/.cargo"
fi

# Rancher Desktop
if [[ -d "$HOME/.rd" ]]; then
  addToPath $HOME/.rd/bin
fi

## mkcert
if [[ -f "$DOTFILES/local/mkcert" ]]; then
  echo "mkcert"
  addToPath $DOTFILES/local
fi

## openssl
if [[ -d "/usr/local/opt/openssl@3" ]]; then
  # echo "/usr/local/opt/openssl@3"
  addToPath /usr/local/opt/openssl@3/bin
  # For compilers to find openssl@3 you may need to set:
  export  LDFLAGS="-L/usr/local/opt/openssl@3/lib"
  export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
  # For pkg-config to find openssl@3 you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"
fi
if [[ -d "$HOMEBREW_PREFIX/opt/openssl@3" ]]; then
  # echo "$HOMEBREW_PREFIX/opt/openssl@3"
  addToPath $HOMEBREW_PREFIX/opt/openssl@3/bin
  # For compilers to find openssl@3 you may need to set:
  export  LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
  # For pkg-config to find openssl@3 you may need to set:
  export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/openssl@3/lib/pkgconfig"
fi

## quic(ngtcp2)
if [[ -d "$DOTFILES/pkg/quic" ]]; then
  echo "ngtcp2"
  addToPath $DOTFILES/pkg/quic/ngtcp2/examples
  alias qserver="server localhost.jxck.io 5000 $DOTFILES/keys/privkey.pem $DOTFILES/keys/cert.pem"
  alias qclient="client localhost.jxck.io 5000 https://localhost.jxck.io:5000"
fi

## webpkgserver
if [[ -d "$DOTFILES/local/webpkgserver" ]]; then
  # echo "webpkgserver"
  addToPath $DOTFILES/local/webpkgserver
fi

## gcloud
if [[ $PATH != *"/pkg/google-cloud-sdk"* ]]; then
  # echo "google-cloud-sdk"
  if [[ -d "$HOMEBREW_PREFIX/share/google-cloud-sdk" ]]; then
    source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"
    source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
  fi
fi

## jxck.io/.src/formatter.js
if [[ -d "$DEV/jxck.io/.src" ]]; then
  # echo "formatter.js"
  addToPath $DEV/jxck.io/.src
fi

if [[ -d "$HOME/.local/bin" ]]; then
  # echo "whisper"
  addToPath $HOME/.local/bin
fi

## Java (Corretto17)
if [[ -f "/usr/libexec/java_home" ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17)
fi

## Open Tmux session in first open shell
# default Shell(zsh) => tmux => zsh
# if [[ $SHLVL == 1 && $TMUX == "" ]]; then
#   echo -n "attach?(y/n/x): " && read attach
#   echo $attach
#
#   if [[ $attach == "x" ]]; then
#     return
#   fi
#
#   # try attache tmux when connect via ssh
#   if [[ $attach == "y" && "${SSH_CONNECTION-}" != "" ]]; then
#     tmux a -d || tmux
#   else
#     tmux
#   fi
# fi

if [[ $PWD =~ jxck.io ]]; then
  ## MAKEFLAGS
  export MAKEFLAGS="--no-builtin-rules -j$(core)"
  echo $MAKEFLAGS
else
  unset MAKEFLAGS
fi
