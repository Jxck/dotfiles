alias psp="ps aux | peco"
alias killp="ps aux | peco | awk '{print \$2}' | xargs kill -9"

function cdp() {
  cd $(find . -maxdepth 4 -type d ! -path "*/.*" | peco)
}

function cdgo() {
  cd $GOPATH/src && cdp
}

function vimp() {
  if git ls-files; then
    vim `git ls-files | peco`
  else
    vim `tree | peco`
  fi
}

function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history
