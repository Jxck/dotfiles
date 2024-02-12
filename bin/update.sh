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
  brew update
  brew upgrade
fi

if [[ -d $DEV/jxck.io ]]; then
  echo "fetch jxck.io"
  cd $DEV/jxck.io
  git f
fi

if [[ -d $DOTFILES ]]; then
  echo "fetch dotfiles"
  cd $DOTFILES
  git f
fi

# rbenv
rbenv update

# update NeoBundle
# vim -c ':NeoBundleUpdate' -c q
