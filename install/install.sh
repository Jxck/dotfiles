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
if [ `uname` = "Linux" ]; then
  if uname -a | grep ubuntu -i >/dev/null; then

    #########
    # ubuntu
    #########
    sudo apt update
    sudo apt install -y \
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
      apcalc \
      source-highlight \
      exuberant-ctags \
      zopfli \
      nkf \
      fonttools \
      gnome-tweak-tool \
      autossh \
      exfat-fuse \
      exfat-utils \
      moreutils
  else
    #########
    # cent
    #########

    # JST time
    sudo cp /usr/share/zoneinfo/Japan /etc/localtime
    # package for build
    sudo yum install -y git gcc-c++ openssl-devel make
  fi
elif [ `uname` = "Darwin" ]; then
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
    libev \
    git \
    tmux \
    tree \
    zsh \
    wget \
    nkf \
    reattach-to-user-namespace \
    jq \
    w3m \
    calc \
    sqlite3 \
    source-highlight \
    ctags \
    zopfli \
    fonttools

  # Change default PATH order in mac for homebrew
  if ! diff /etc/paths $DOTFILES/misc/mac.paths >/dev/null ; then
    sudo mv /etc/paths /etc/paths.orig
    sudo cp $DOTFILES/misc/mac.paths /etc/paths
  fi
fi

# link dotfiles to home
$DOTFILES/bin/slink.sh

# chsh to zsh
$DOTFILES/bin/chsh.sh
