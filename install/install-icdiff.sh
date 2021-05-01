#!/usr/bin/env zsh

if [[ `uname` == "Darwin" ]]; then
  echo "install via brew"
  exit 0
fi

DEST=$DOTFILES/local/icdiff
rm -rf $DEST
git clone --depth 1 https://github.com/jeffkaufman/icdiff $DEST
