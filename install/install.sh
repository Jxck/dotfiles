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
# distoribute
###################

## install home brew first in macOS/Ubuntu
if !(type brew > /dev/null 2>&1); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  source $DOTFILES/.zprofile
fi

if [[ `uname` == "Linux" ]]; then
  #########
  # ubuntu
  #########
  sudo apt update
  sudo apt install -y --ignore-missing \
    build-essential \
    cmake \
    coreutils \
    apt-utils \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libncurses5-dev \
    libxml2-dev \
    libxslt1-dev \
    libpcre3 \
    libpcre3-dev \
    libev4 \
    libev-dev \
    libevent-dev \
    libpng-dev \
    zlib1g-dev \
    tree \
    xsel \
    vim \
    git \
    zsh \
    jq \
    w3m \
    curl \
    unzip \
    calc \
    source-highlight \
    exuberant-ctags \
    zopfli \
    nkf \
    fonttools \
    gnome-tweaks \
    autossh \
    exfat-fuse \
    exfat-utils \
    moreutils \
    autoconf \
    bison \
    libyaml-dev \
    libffi-dev \
    libgdbm-dev \
    mp3info \
    apache2-utils \
    clang-format \
    eyed3 \
    pngquant \
    optipng \
    duf

elif [[ `uname` == "Darwin" ]]; then
  brew install \
    coreutils \
    findutils \
    gnu-sed \
    gnu-tar \
    gnu-time \
    grep \
    diffutils \
    gzip \
    gawk \
    cmake \
    libev \
    git \
    tmux \
    tree \
    zsh \
    wget \
    nkf \
    jq \
    gh \
    w3m \
    calc \
    sqlite3 \
    source-highlight \
    ctags \
    zopfli \
    fonttools \
    vim \
    peco \
    icdiff \
    brotli \
    webp \
    duf

  brew tap homebrew/cask-fonts
  brew install --cask cmake font-source-han-code-jp

  brew tap tldr-pages/tldr
  brew install tldr

  # for zsh compinit errro fix
  chmod 755 /usr/local/share/zsh/site-functions
  chmod 755 /usr/local/share/zsh
fi

# neobundle install
cd $DOTFILES
git submodule init
git submodule update

# link dotfiles to home
$DOTFILES/bin/slink.sh

# chsh to zsh
$DOTFILES/bin/chsh.sh
