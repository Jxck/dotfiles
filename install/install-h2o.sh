#!/usr/bin/env zsh

if [[ `uname` == "Linux" ]]; then
  sudo apt update
  sudo apt install -y \
    mruby \
    bison
elif [[ `uname` == "Darwin" ]]; then
  brew install \
    mruby
fi

cd $DOTFILES/pkg
DEST=$DOTFILES/pkg/h2o
\rm -rf $DEST

# ghlatest h2o/h2o
git clone --depth=1 https://github.com/h2o/h2o

cd $DEST
cmake -DCMAKE_INSTALL_PREFIX=$DOTFILES/local/h2o -DWITH_MRUBY=on -DWITH_BUNDLED_SSL=on .
make
make install
