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

# Linux Brew の requirements を入れる
# https://docs.brew.sh/Homebrew-on-Linux#requirements
if [[ `uname` == "Linux" ]]; then
  sudo apt update
  sudo apt install -y --ignore-missing \
    build-essential \
    procps \
    curl \
    file \
    git \
    zsh
fi

## Homebrew のインストール (macOS/Ubuntu 共通)
if ! type brew > /dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # brew に PATH を通す
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  brew bundle --file=$DOTFILES/Brewfile
fi

# link dotfiles to home
$DOTFILES/bin/slink.sh

# Linux のみ: デフォルトシェルを zsh に変更
# macOS は zsh がデフォルトシェルのため不要
if [[ $(uname) == "Linux" ]]; then
  sudo chsh -s "$(which zsh)" "$USER"
fi