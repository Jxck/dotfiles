#!/usr/bin/env zsh

echo "install via brew"
exit 0

#if [[ `uname` == "Linux" ]]; then
#  sudo apt update
#  sudo apt install -y \
#    automake \
#    pkg-config
#elif [[ `uname` == "Darwin" ]]; then
#  brew install \
#    automake \
#    pkg-config
#fi
#
#rm -rf $DOTFILES/pkg/tmux
#rm -rf $DOTFILES/local/tmux
#
#cd $DOTFILES/pkg
#gh release download -R tmux/tmux 3.2a
#unpack tmux-3.2a.tar.gz
#cd $DOTFILES/pkg/tmux-3.2a/tmux-3.2a
#
#./configure --prefix=$DOTFILES/local/tmux
#make
#make install
