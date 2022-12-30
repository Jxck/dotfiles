## Completion configuration
autoload -U compinit
compinit

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
  case ":$PATH:" in
    *":$1:"*) PATH="$1:${PATH/:$1/}" ;; # already there
    *) PATH="$1:$PATH";; # or PATH="$PATH:$1"
  esac
}

## coreutils
export MANPATH=/usr/local/coreutils/libexec/gnuman:$MANPATH
addToPath /usr/local/coreutils/libexec/gnubin

[[ -d "$DOTFILES/bin"                  ]] && addToPath $DOTFILES/bin
[[ -d "$DOTFILES/local/openssl/bin"    ]] && addToPath $DOTFILES/local/openssl/bin
[[ -d "$DOTFILES/local/tmux"           ]] && addToPath $DOTFILES/local/tmux/bin
[[ -d "$DOTFILES/local/brotli"         ]] && addToPath $DOTFILES/local/brotli/bin
[[ -d "$DOTFILES/local/certbot-auto"   ]] && addToPath $DOTFILES/local/certbot-auto
[[ -d "$DOTFILES/local/icdiff"         ]] && addToPath $DOTFILES/local/icdiff && alias diff=icdiff
[[ -d "$DOTFILES/local/peco"           ]] && addToPath $DOTFILES/local/peco
[[ -d "$DOTFILES/local/websocketd"     ]] && addToPath $DOTFILES/local/websocketd
[[ -d "$DOTFILES/local/weighttp"       ]] && addToPath $DOTFILES/local/weighttp/bin
[[ -d "$DOTFILES/local/libsrtp/test"   ]] && addToPath $DOTFILES/local/libsrtp/test
[[ -d "$DOTFILES/local/rebar3"         ]] && addToPath $DOTFILES/local/rebar3
[[ -d "$DOTFILES/local/depot_tools"    ]] && addToPath $DOTFILES/local/depot_tools
[[ -d "$DOTFILES/local/diff-highlight" ]] && addToPath $DOTFILES/local/diff-highlight
[[ -d "$DOTFILES/local/gh-cli"         ]] && addToPath $DOTFILES/local/gh-cli/bin
[[ -d "$DOTFILES/pkg/nghttp2"          ]] && addToPath $DOTFILES/pkg/nghttp2/src

## iterm2_shell_integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# browser ssl master secret
# export SSLKEYLOGFILE=~/SSLKEYLOGFILE.log

# include
[[ `uname` == "Darwin" && -f $DOTFILES/zsh/mac.zsh    ]] && source $DOTFILES/zsh/mac.zsh
[[ `uname` == "Linux"  && -f $DOTFILES/zsh/ubuntu.zsh ]] && source $DOTFILES/zsh/ubuntu.zsh

[[ -f $DOTFILES/zsh/common.zsh            ]] && source $DOTFILES/zsh/common.zsh
[[ -f $DOTFILES/zsh/help.zsh              ]] && source $DOTFILES/zsh/help.zsh
[[ -f $DOTFILES/zsh/peco.zsh              ]] && source $DOTFILES/zsh/peco.zsh
[[ -f $DOTFILES/zsh/showbranch.zsh        ]] && source $DOTFILES/zsh/showbranch.zsh
[[ -f $DOTFILES/zsh/rails_alias.zsh       ]] && source $DOTFILES/zsh/rails_alias.zsh
[[ -f $DOTFILES/zsh/http_status_codes.zsh ]] && source $DOTFILES/zsh/http_status_codes.zsh

# nodebrew
if [[ -f $DOTFILES/pkg/nodebrew/nodebrew ]]; then
  export NODEBREW_ROOT=$DOTFILES/pkg/nodebrew
  addToPath $NODEBREW_ROOT/current/bin
  out=`nodebrew use v19`
  . <(npm completion)
  alias npmls="npm ls --depth 0"

  # always add path of $DOTFILES/node_modules/.bin before
  addToPath $DOTFILES/node_modules/.bin

  # always add path of current repo
  addToPath ./node_modules/.bin

  echo nodebrew $out
fi

# rbenv
if [[ -d "$DOTFILES/pkg/rbenv/bin" ]]; then
  VERSION=3.1.0
  export RBENV_ROOT=$DOTFILES/pkg/rbenv
  addToPath $DOTFILES/pkg/rbenv/bin
  addToPath $DOTFILES/pkg/rbenv/shims
  rbenv global $VERSION
  # eval "$(rbenv init -)"
  echo "rbenv use:" $VERSION
fi

# gobrew
if [[ -d "$DOTFILES/pkg/go" ]]; then
  export GOROOT=$DOTFILES/pkg/go/current
  addToPath $GOROOT/bin
  addToPath $HOME/go/bin

  # add more GOPATH
  source $DOTFILES/pkg/go/.gopath
  echo "gobrew GOPATH: $GOPATH"
fi

# cargo (TODO: move to $DOTFILES)
if [[ -d "$HOME/.cargo" ]]; then
  echo "cargo"
  addToPath $HOME/.cargo/bin
  export CARGO_NAME=Jxck
  export CARGO_EMAIL=''
  echo "Cargo: $HOME/.cargo"
fi

## mkcert
if [[ -f "$DOTFILES/local/mkcert" ]]; then
  echo "mkcert"
  addToPath $DOTFILES/local
fi

# # mvn
# if [[ -d "$DOTFILES/pkg/mvn" ]]; then
#   echo "MVN"
#   # export path
#   export M2_HOME=$DOTFILES/pkg/mvn
#   addToPath $M2_HOME/bin
#   echo "M2_HOME: $M2_HOME"
#
#   # antlr
#   export CLASSPATH=$DOTFILES/pkg/antlr/antlr-4.7.1-complete.jar:$CLASSPATH
#   alias antlr4='java -jar $DOTFILES/pkg/antlr/antlr-4.7.1-complete.jar'
#   alias grun='java org.antlr.v4.gui.TestRig'
# fi

## openssl
if [[ -d "/usr/local/opt/openssl@3/bin" ]]; then
  echo "openssl@3"
  addToPath /usr/local/opt/openssl@3/bin
  # A CA file has been bootstrapped using certificates from the system
  # keychain. To add additional certificates, place .pem files in
  #   /usr/local/etc/openssl@3/certs
  #
  # and run
  #   /usr/local/opt/openssl@3/bin/c_rehash
  #
  # openssl@3 is keg-only, which means it was not symlinked into /usr/local,
  # because macOS provides LibreSSL.
  #
  # If you need to have openssl@3 first in your PATH, run:
  #   echo 'export PATH="/usr/local/opt/openssl@3/bin:$PATH"' >> ~/.zshrc
  #
  # For compilers to find openssl@3 you may need to set:
  #   export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
  #   export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
  #
  # For pkg-config to find openssl@3 you may need to set:
  #   export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"
fi

## quic(ngtcp2)
if [[ -d "$DOTFILES/pkg/quic" ]]; then
  echo "ngtcp2"
  addToPath $DOTFILES/pkg/quic/ngtcp2/examples
  alias qserver="server localhost.jxck.io 5000 $DOTFILES/keys/privkey.pem $DOTFILES/keys/cert.pem"
  alias qclient="client localhost.jxck.io 5000 https://localhost.jxck.io:5000"
fi

## webp
if [[ -d "$DOTFILES/pkg/webp" ]]; then
  echo "webp"
  addToPath $DOTFILES/pkg/webp/bin
fi

## webpkgserver
if [[ -d "$DOTFILES/local/webpkgserver" ]]; then
  echo "webpkgserver"
  addToPath $DOTFILES/local/webpkgserver
fi

## gcloud
if [[ $PATH != *"/pkg/google-cloud-sdk"* ]]; then
  echo "google-cloud-sdk"
  if [[ -d "/usr/local/Caskroom/google-cloud-sdk" ]]; then
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
    export GOOGLE_APPLICATION_CREDENTIALS=$DOTFILES/keys/jxck-gcp-fc6051c8222c.json
  fi
  if [[ -d "/home/jxck/dotfiles/pkg/google-cloud-sdk" ]]; then
    source "/home/jxck/dotfiles/pkg/google-cloud-sdk/path.zsh.inc"
    source "/home/jxck/dotfiles/pkg/google-cloud-sdk/completion.zsh.inc"
  fi
fi

## libavif - avifenc/dec
if [[ -d "$DOTFILES/pkg/libavif" ]]; then
  echo "libavif"
  addToPath $DOTFILES/pkg/libavif/build
fi

## guetzli
if [[ -d "$DOTFILES/pkg/guetzli" ]]; then
  echo "guetzli"
  addToPath $DOTFILES/pkg/guetzli/bin/Release
fi

## jxck.io/.src/formatter.js
if [[ -d "$DEV/jxck.io/.src" ]]; then
  echo "formatter.js"
  addToPath $DEV/jxck.io/.src
fi

# default Shell(zsh) => tmux => zsh
if [[ $SHLVL == 1 && $TMUX == "" ]]; then
  # echo "who last login"
  # if [[ `uname` == "Darwin" ]]; then
  #   last -10 | awk '{print $3}' U
  # else
  #   last -dw -n 10 | awk '{print $3}' U
  # fi

  echo -n "attach?(y/n/x): " && read attach
  echo $attach

  if [[ $attach == "x" ]]; then
    return
  fi

  # try attache tmux when connect via ssh
  if [[ $attach == "y" && "${SSH_CONNECTION-}" != "" ]]; then
    tmux a -d || tmux
  else
    tmux
  fi
fi

# display os
os

if [[ $PWD =~ jxck.io ]]; then
  ## MAKEFLAGS
  export MAKEFLAGS="--no-builtin-rules -j$(core)"
  echo $MAKEFLAGS
else
  unset MAKEFLAGS
fi

# sync history
# ( hist & ) 1>/dev/null 2>/dev/null
