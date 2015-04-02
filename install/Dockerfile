FROM ubuntu

RUN apt-get update
RUN apt-get upgrade

RUN apt-get install -y gcc
RUN apt-get install -y build-essential
RUN apt-get install -y libssl-dev
RUN apt-get install -y libreadline6-dev
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libxslt1-dev
RUN apt-get install -y libpcre3
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y libev4
RUN apt-get install -y libev-dev

RUN apt-get install -y xsel
RUN apt-get install -y vim-gnome
RUN apt-get install -y git-core
RUN apt-get install -y zsh
RUN apt-get install -y jq
RUN apt-get install -y wget
RUN apt-get install -y curl

RUN apt-get install -y libgoogle-perftools-dev

RUN apt-get install -y apache2-utils

RUN git clone https://github.com/jxck/dotfiles $HOME/dotfiles
RUN chsh -s /usr/bin/zsh

RUN $HOME/dotfiles/bin/slink.sh

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root
