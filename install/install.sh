#!/usr/bin/env bash

echo "==================="
read -p "passwd for root & ubuntu has done ??(y/n): " DONE

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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  source $DOTFILES/.zprofile
fi

brew install \
  brotli \
  calc \
  cmake \
  coreutils \
  ctags \
  diffutils \
  duf \
  findutils \
  fonttools \
  gh \
  git \
  gnu-sed \
  gnu-tar \
  gnu-time \
  grep \
  gzip \
  icdiff \
  jq \
  libev \
  nkf \
  peco \
  source-highlight \
  sqlite3 \
  tmux \
  tree \
  vim \
  webp \
  wget \
  zopfli \
  zsh

#apache2-utils \
#apt-utils \
#autoconf \
#autossh \
#bison \
#clang-format \
#exfat-fuse \
#exfat-utils \
#exuberant-ctags \
#eyed3 \
#fonttools \
#gnome-tweaks \
#libev-dev \
#libev4 \
#libevent-dev \
#libffi-dev \
#libgdbm-dev \
#libncurses5-dev \
#libpcre3 \
#libpcre3-dev \
#libpng-dev \
#libreadline-dev \
#libssl-dev \
#libxml2-dev \
#libxslt1-dev \
#libyaml-dev \
#moreutils \
#mp3info \
#optipng \
#pngquant \
#source-highlight \
#unzip \
#xsel \
#zlib1g-dev \
#zsh


# for zsh compinit errro fix
## chmod 755 /usr/local/share/zsh/site-functions
## chmod 755 /usr/local/share/zsh

# neobundle install
cd $DOTFILES
git submodule init
git submodule update

# link dotfiles to home
$DOTFILES/bin/slink.sh

# chsh to zsh
$DOTFILES/bin/chsh.sh
