###################
# common
###################
echo "alias ls='ls -la --col'" >> ~/.bashrc

###################
# distoribute
###################
if [ `uname` = "Linux" ]; then
  if uname -a | grep ubuntu -i >/dev/null; then
    #########
    # ubuntu
    #########
    sudo apt-get update
    sudo apt-get install -y \
      build-essential \
      libssl-dev \
      libreadline6-dev \
      libncurses5-dev \
      libxml2-dev \
      libxslt1-dev \
      libpcre3 \
      libpcre3-dev \
      libev4 \
      libev-dev \
      tree \
      xsel \
      tmux \
      vim-gnome \
      git-core \
      zsh \
      jq \
      w3m \
      curl \
      apcalc \
      source-highlight

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
    tree \
    zsh \
    tmux \
    rmtrash \
    wget \
    nkf \
    reattach-to-user-namespace \
    jq \
    w3m \
    calc \
    source-highlight

  # Change default PATH order in mac for homebrew
  if ! diff /etc/paths $HOME/dotfiles/misc/mac.paths >/dev/null ; then
    sudo mv /etc/paths /etc/paths.orig
    sudo cp $HOME/dotfiles/misc/mac.paths /etc/paths
  fi
fi
