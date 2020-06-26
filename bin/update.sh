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
fi

if [ -z "$DOTFILES" ]; then
  cdj
  git f
  cd -
fi

if [ -z "$SERVER" ]; then
  cdj
  git f
  cd -
fi

# rbenv
rbenv update
