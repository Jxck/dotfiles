alias psp="ps aux | peco"

function killp() {
  if [ `uname` = "Linux" ]; then
    ps ax --forest | peco | awk "{print \$1}" | xargs kill -9
  elif [ `uname` = "Darwin" ]; then
    ps ax | peco | awk "{print \$1}" | xargs kill -9
  fi
}

# move to directory found with peco
# if passing file, move to dir of there
function cdp() {
  local P
  if [[ $PWD = $HOME ]]; then
    P=$(find ./ $1 -maxdepth 3 ! -path "*/.*" | cat | peco | sed "s|~|$HOME|")
  else
    P=$(find ./ $1 -maxdepth 4 ! -path "*/.*" | cat | peco | sed "s|~|$HOME|")
  fi
  if test -d $P; then
    cd $P
  else
    cd $(dirname $P)
  fi
}

# move to GPATH/src
function cdgo() {
  cd $GOPATH/src
}

# open file found with peco in vim
function vimp() {
  if git rev-parse 2> /dev/null; then
    vim $(git ls-files | peco)
  else
    vim $(find ./ $1 -maxdepth 3 | peco)
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
