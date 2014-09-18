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
      tree \
      xsel \
      tmux \
      vim-gnome \
      git-core \
      zsh \

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
    redis \
    rmtrash \
    wget \
    nkf \
    reattach-to-user-namespace \
fi
