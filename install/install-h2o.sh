if [ `uname` = "Linux" ]; then
  sudo apt-get update
  sudo apt-get install -y \
    mruby \
    bison
elif [ `uname` = "Darwin" ]; then
  brew install \
    mruby
fi

cd $DOTFILES/pkg
ghlatest h2o/h2o
cd h2o
cmake -DCMAKE_INSTALL_PREFIX=$DOTFILES/local/h2o -DWITH_MRUBY=on -DWITH_BUNDLED_SSL=on .
make
make install
