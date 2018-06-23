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
      libreadline6-dev \
      libncurses5-dev \
      libxml2-dev \
      libxslt1-dev \
      libpcre3 \
      libpcre3-dev \
      libev4 \
      libev-dev \
      libevent-dev \
      tree \
      xsel \
      vim-gnome \
      git-core \
      zsh \
      jq \
      w3m \
      curl \
      unzip \
      apcalc \
      source-highlight \
      ctags \
      zopfli \
      nkf

    $DOTFILES/install/install-tmux2.sh
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
    diffutils --with-default-names \
    findutils --with-default-names \
    gnu-sed   --with-default-names \
    gnu-tar   --with-default-names \
    grep      --with-default-names \
    gzip      --with-default-names \
    gawk      --with-default-names \
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
    zopfli

  # Change default PATH order in mac for homebrew
  if ! diff /etc/paths $DOTFILES/misc/mac.paths >/dev/null ; then
    sudo mv /etc/paths /etc/paths.orig
    sudo cp $DOTFILES/misc/mac.paths /etc/paths
  fi
fi

# install default
$DOTFILES/install/install-icdiff.sh*
$DOTFILES/install/install-peco.sh*

# link dotfiles to home
$DOTFILES/bin/slink.sh

# chsh to zsh
$DOTFILES/bin/chsh.sh
