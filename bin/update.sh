#!/usr/bin/env bash

if [[ `uname` == "Linux" ]]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt clean
  sudo apt full-upgrade -y
  do-release-upgrade -c
  fwupdmgr get-upgrades
fi

brew update
brew upgrade

mise completion zsh > $DOTFILES/zsh/mise.completion.zsh
mise uninstall -a
mise prune -y
mise install

if [[ -d $DEV/jxck.io ]]; then
  echo "fetch jxck.io"
  cd $DEV/jxck.io
  git f
  npm i
fi

if [[ -d $DOTFILES ]]; then
  echo "fetch dotfiles"
  cd $DOTFILES
  git f
  npm i
fi
