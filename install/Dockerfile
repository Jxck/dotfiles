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

RUN apt update
#RUN apt upgrade

RUN apt install -y gcc
RUN apt install -y build-essential
RUN apt install -y libssl-dev
RUN apt install -y libreadline6-dev
RUN apt install -y libncurses5-dev
RUN apt install -y libxml2-dev
RUN apt install -y libxslt1-dev
RUN apt install -y libpcre3
RUN apt install -y libpcre3-dev
RUN apt install -y libev4
RUN apt install -y libev-dev

RUN apt install -y vim-gnome
RUN apt install -y git-core
RUN apt install -y zsh
RUN apt install -y jq
RUN apt install -y wget
RUN apt install -y curl
RUN apt install -y tmux
RUN apt install -y tree

# Install Tools
RUN apt install -y libgoogle-perftools-dev
RUN apt install -y apache2-utils

# Get dotfiles
RUN git clone --depth 1 https://github.com/jxck/dotfiles  $DOTFILES
RUN chsh -s /usr/bin/zsh
RUN $DOTFILES/bin/slink.sh

RUN $DOTFILES/install/install-weighttp.sh
