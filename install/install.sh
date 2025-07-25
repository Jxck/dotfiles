#!/usr/bin/env bash

echo "==================="

# -y オプションが渡された場合はプロンプトをスキップ
if [[ "$1" == "-y" ]]; then
  DONE="y"
  echo "Skipping password confirmation (auto-yes mode)"
else
  read -p "passwd for root & ubuntu has done ??(y/n): " DONE
fi

if test $DONE != "y"; then
  echo "set passwd first"
  echo "$ sudo su -"
  echo "$ passwd"
  echo "$ passwd ubuntu"
  exit 0
fi
echo "continue"

###################
# common
###################
echo "alias ls='ls -la --col'" >> ~/.bashrc

export DOTFILES=$HOME/dotfiles
echo DOTFILES=$DOTFILES

###################
# package
###################

if [[ `uname` == "Linux" ]]; then
  sudo apt update
  sudo apt install -y --ignore-missing \
    build-essential \
    procps \
    curl \
    file \
    git
fi

## install home brew first in macOS/Ubuntu
if !(type brew > /dev/null 2>&1); then
  export HOMEBREW_NO_INSTALL_FROM_API=1
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  source $DOTFILES/.zprofile
  # install first bundle
  brew bundle --file=$DOTFILES/Brewfile
fi

# for zsh compinit error fix
## chmod 755 /usr/local/share/zsh/site-functions
## chmod 755 /usr/local/share/zsh

# link dotfiles to home
$DOTFILES/bin/slink.sh

# chsh to zsh
# $DOTFILES/bin/chsh.sh
