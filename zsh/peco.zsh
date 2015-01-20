alias psp="ps aux | peco"
alias killp="ps aux | peco | awk '{print \$2}' | xargs kill -9"

# move to directory found with peco
function cdp() {
  cd $(find . -maxdepth 4 -type d ! -path "*/.*" | peco)
}

# move to GPATH/src
function cdgo() {
  cd $GOPATH/src
}

# open file found with peco in vim
function vimp() {
  if git ls-files; then
    vim `git ls-files | peco`
  else
    vim `tree | peco`
  fi
}

# ignore duplicates from history
function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
}
zle -N peco-select-history
bindkey '^r' peco-select-history
