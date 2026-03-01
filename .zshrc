## 補完設定
autoload -U compinit

# PATH の重複を除去
typeset -U path

# エイリアスでも補完を有効にする
setopt complete_aliases

# 言語設定
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# REPORTTIME 秒以上かかったコマンドの実行時間を表示
export REPORTTIME=1

# Tab で補完候補を自動表示
setopt auto_menu

# ディレクトリ名だけで cd
setopt auto_cd

# ブレース展開を有効にする
setopt brace_ccl

# cd 時に自動で pushd (cd -[tab] でディレクトリ一覧)
setopt auto_pushd

# pushd でディレクトリスタックに重複を追加しない
setopt pushd_ignore_dups

# 補完候補をコンパクトに表示
setopt list_packed

# 補完時のビープ音を無効にする
setopt nolistbeep

# glob がマッチしなくてもエラーにしない
setopt nonomatch

# Emacs キーバインド (Ctrl-a, Ctrl-e など)
bindkey -e

# 複数リダイレクト (例: echo "hello" > a.txt > b.txt)
setopt multios

# Ctrl-S によるフロー制御を無効にする
stty stop undef

# ^P/^N で行頭一致のヒストリ検索
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 失敗したコマンドを履歴に追加しない
zshaddhistory() {
  __last_hist="${1%%$'\n'}"
  return 1  # 一旦履歴に追加しない
}
__save_successful_history() {
  [[ $? -eq 0 && -n "$__last_hist" ]] && print -sr -- "$__last_hist"
  __last_hist=""
}
precmd_functions=(__save_successful_history $precmd_functions)

## 環境変数
export DOTFILES=$HOME/dotfiles

## コマンド履歴設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_all_dups # 履歴全体で重複を削除し最新を残す
setopt hist_ignore_space    # スペースで始まるコマンドを履歴に追加しない
setopt hist_reduce_blanks   # 履歴保存時に余分なスペースを削除
setopt share_history        # 履歴をセッション間で共有

# PATH の先頭に追加
function addToPath {
  PATH="$1:$PATH"
}

# Homebrew の環境変数を設定
# brew shellenv のキャッシュ (update.sh で更新)
local os=$(uname)
if [[ $os == "Darwin" ]]; then
  source $DOTFILES/zsh/brew.shellenv.mac.zsh
elif [[ $os == "Linux" ]]; then
  source $DOTFILES/zsh/brew.shellenv.linux.zsh
fi

# BSD コマンドを GNU コマンドに置き換え
[[ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]] && addToPath $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
[[ -d "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin" ]] && addToPath $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
[[ -d "$HOMEBREW_PREFIX/opt/diffutils/bin"            ]] && addToPath $HOMEBREW_PREFIX/opt/diffutils/bin
[[ -d "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"   ]] && addToPath $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
[[ -d "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"   ]] && addToPath $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
[[ -d "$HOMEBREW_PREFIX/opt/gnu-time/libexec/gnubin"  ]] && addToPath $HOMEBREW_PREFIX/opt/gnu-time/libexec/gnubin
[[ -d "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"      ]] && addToPath $HOMEBREW_PREFIX/opt/grep/libexec/gnubin

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

## iTerm2 シェル統合
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# ブラウザの TLS マスターシークレットをログ
export SSLKEYLOGFILE=$HOME/SSLKEYLOGFILE.log

####################################
## ここまでに FPATH は全て設定する。
####################################
# -C: セキュリティチェック(compaudit)をスキップし、キャッシュがあれば再利用
compinit -C

# 1Password 補完
# op completion zsh のキャッシュ (update.sh で更新)
source $DOTFILES/zsh/op.completion.zsh; compdef _op op

# 追加設定の読み込み
[[ $os == "Darwin" && -f $DOTFILES/zsh/mac.zsh    ]] && source $DOTFILES/zsh/mac.zsh
[[ $os == "Linux"  && -f $DOTFILES/zsh/ubuntu.zsh ]] && source $DOTFILES/zsh/ubuntu.zsh

[[ -f $DOTFILES/zsh/common.zsh            ]] && source $DOTFILES/zsh/common.zsh
[[ -f $DOTFILES/zsh/help.zsh              ]] && source $DOTFILES/zsh/help.zsh
[[ -f $DOTFILES/zsh/fzf.zsh               ]] && source $DOTFILES/zsh/fzf.zsh
[[ -f $DOTFILES/zsh/showbranch.zsh        ]] && source $DOTFILES/zsh/showbranch.zsh
[[ -f $DOTFILES/zsh/rails_alias.zsh       ]] && source $DOTFILES/zsh/rails_alias.zsh
[[ -f $DOTFILES/zsh/http_status_codes.zsh ]] && source $DOTFILES/zsh/http_status_codes.zsh

# mise (ツールバージョン管理)
if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
  source $DOTFILES/zsh/mise.completion.zsh
  export MISE_GLOBAL_CONFIG_FILE=$DOTFILES/.mise.toml
  #export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc --disable-install-capi"
fi

# Rancher Desktop
if [[ -d "$HOME/.rd" ]]; then
  addToPath $HOME/.rd/bin
fi

## mkcert
if [[ -f "$DOTFILES/local/mkcert" ]]; then
  # echo "mkcert"
  addToPath $DOTFILES/local
fi

## openssl
if [[ -d "/usr/local/opt/openssl@3" ]]; then
  # echo "/usr/local/opt/openssl@3"
  addToPath /usr/local/opt/openssl@3/bin
  # コンパイラ用
  export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
  export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
  # pkg-config 用
  export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"
fi
if [[ -d "$HOMEBREW_PREFIX/opt/openssl@3" ]]; then
  # echo "$HOMEBREW_PREFIX/opt/openssl@3"
  addToPath $HOMEBREW_PREFIX/opt/openssl@3/bin
  # コンパイラ用
  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
  # pkg-config 用
  export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/openssl@3/lib/pkgconfig"
fi

## QUIC (ngtcp2)
if [[ -d "$DOTFILES/pkg/quic" ]]; then
  # echo "ngtcp2"
  addToPath $DOTFILES/pkg/quic/ngtcp2/examples
  alias qserver="server localhost.jxck.io 5000 $DOTFILES/keys/privkey.pem $DOTFILES/keys/cert.pem"
  alias qclient="client localhost.jxck.io 5000 https://localhost.jxck.io:5000"
fi

## webpkgserver
if [[ -d "$DOTFILES/local/webpkgserver" ]]; then
  # echo "webpkgserver"
  addToPath $DOTFILES/local/webpkgserver
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
# if [[ -f "/usr/libexec/java_home" ]]; then
#   export JAVA_HOME=$(/usr/libexec/java_home -v 17)
# fi

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
#   # try attach tmux when connect via ssh
#   if [[ $attach == "y" && "${SSH_CONNECTION-}" != "" ]]; then
#     tmux a -d || tmux
#   else
#     tmux
#   fi
# fi

# jxck.io ディレクトリでは MAKEFLAGS を設定
if [[ $PWD =~ jxck\.io ]]; then
  export MAKEFLAGS="--no-builtin-rules -j$(core)"
  echo $MAKEFLAGS
else
  unset MAKEFLAGS
fi
