#!/usr/bin/env bash

if [[ `uname` == "Darwin" ]]; then
  sudo chown -R $(whoami) /usr/local/bin /usr/local/etc /usr/local/sbin /usr/local/share /usr/local/share/doc
  chmod u+w /usr/local/bin /usr/local/etc /usr/local/sbin /usr/local/share /usr/local/share/doc
  export HOMEBREW_INSTALL_CLEANUP=1 brew cleanup
  cd $(brew --repo)
  git fetch
  git reset --hard origin/master
  brew update
  brew upgrade
fi

if [[ `uname` == "Linux" ]]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt clean
  sudo apt full-upgrade -y
  do-release-upgrade -c
  fwupdmgr get-upgrades
fi

if [[ -n $SERVER ]]; then
  echo "fetch jxck.io"
  cd $SERVER/jxck.io
  git f
fi

if [[ -n $DOTFILES ]]; then
  echo "fetch dotfiles"
  cd $DOTFILES
  git f
fi

# update NeoBundle
vim -c ':NeoBundleUpdate' -c q

# rbenv
rbenv update
