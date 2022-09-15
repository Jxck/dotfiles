#!/usr/bin/env zsh

if [[ `uname` == "Linux" ]]; then
  brew tap tgotwig/linux-dust && brew install dust
elif [[ `uname` == "Darwin" ]]; then
  brew install dust
fi
