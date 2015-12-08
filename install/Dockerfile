FROM ubuntu

# VERSION = 0.1

# Set environment variables.
ENV HOME /root

ENV DEBIAN_FRONTEND noninteractive

# Proxy setting
ENV http_proxy   $http_proxy
ENV https_proxy  $https_proxy
ENV all_proxy    $all_proxy
ENV no_proxy     $no_proxy
ENV HTTP_PROXY   $HTTP_PROXY
ENV HTTPS_PROXY  $HTTPS_PROXY
ENV ALL_PROXY    $ALL_PROXY
ENV NO_PROXY     $NO_PROXY

# Define working directory.
WORKDIR /root

RUN apt-get update
#RUN apt-get upgrade

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

RUN apt-get install -y vim-gnome
RUN apt-get install -y git-core
RUN apt-get install -y zsh
RUN apt-get install -y jq
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y tmux
RUN apt-get install -y tree

# Install Tools
RUN apt-get install -y libgoogle-perftools-dev
RUN apt-get install -y apache2-utils

# Get dotfiles
RUN git clone https://github.com/jxck/dotfiles  $DOTFILES
RUN chsh -s /usr/bin/zsh
RUN $DOTFILES/bin/slink.sh

RUN $DOTFILES/install/install-weighttp.sh
