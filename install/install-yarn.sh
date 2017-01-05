if [ `uname` = "Linux" ]; then
  if uname -a | grep ubuntu -i >/dev/null; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install yarn
  fi
elif [ `uname` = "Darwin" ]; then
  brew update
  brew install yarn
fi
