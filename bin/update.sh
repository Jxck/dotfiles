if [ `uname` = "Darwin" ]; then
  export HOMEBREW_INSTALL_CLEANUP=1 brew cleanup
  cd $(brew --repo)
  git fetch
  git reset --hard origin/master
  brew update
  brew upgrade
fi

if [ `uname` = "Linux" ]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt clean
  sudo apt full-upgrade -y
  do-release-upgrade -c
  fwupdmgr get-upgrades
fi

if [ -n $SERVER ]; then
  echo "fetch jxck.io"
  cd $SERVER/jxck.io
  git f
fi

if [ -n $DOTFILES ]; then
  echo "fetch dotfiles"
  cd $DOTFILES
  git f
fi

# rbenv
rbenv update
