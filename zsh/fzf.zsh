source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--height 60% --reverse --border'
export FZF_ALT_C_COMMAND='fd --type d'

alias psp="\ps x | fzf"

function killp() {
  if [[ `uname` == "Linux" ]]; then
    ps ax --forest | fzf | awk "{print \$1}" | xargs kill -9
  elif [[ `uname` == "Darwin" ]]; then
    ps ax | fzf | awk "{print \$1}" | xargs kill -9
  fi
}

# fzf-cd-widget (Alt+C) をコマンドとして呼ぶ
function cdp() {
  local dir
  dir=$(fd --type d | fzf) && cd "$dir"
}

# move to GPATH/src
function cdgo() {
  cd $GOPATH/src
}

# open file found with fzf in vim
function vimp() {
  if git rev-parse 2> /dev/null; then
    vim $(git ls-files | fzf --preview 'cat {}')
  else
    vim $(fd --max-depth 3 --type f | fzf --preview 'cat {}')
  fi
}
