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

#apache2-utils \
#apt-utils \
#autoconf \
#autossh \
#bison \
#build-essential \
#calc \
#clang-format \
#cmake \
#coreutils \
#curl \
#duf
#exfat-fuse \
#exfat-utils \
#exuberant-ctags \
#eyed3 \
#fonttools \
#git \
#gnome-tweaks \
#jq \
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
#libsqlite3-dev \
#libssl-dev \
#libxml2-dev \
#libxslt1-dev \
#libyaml-dev \
#moreutils \
#mp3info \
#nkf \
#optipng \
#pngquant \
#source-highlight \
#tree \
#unzip \
#vim \
#w3m \
#xsel \
#zlib1g-dev \
#zopfli \
#zsh


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
  gawk \
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
  w3m \
  webp \
  wget \
  zopfli \
  zsh

  # brew tap homebrew/cask-fonts
  # brew install --cask cmake font-source-han-code-jp

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
