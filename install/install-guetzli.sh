#!/usr/bin/env zsh

cd $DOTFILES/pkg
DEST=$DOTFILES/pkg/guetzli
\rm -rf $DEST

# ghlatest google/guetzli
git clone --depth=1 https://github.com/google/guetzli

cd $DEST
make
