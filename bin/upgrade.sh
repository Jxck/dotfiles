update.sh

if [ `uname` = "Darwin" ]; then
  brew upgrade
fi

if [ `uname` = "Linux" ]; then
  sudo apt full-upgrade -y
  do-release-upgrade -c
fi
