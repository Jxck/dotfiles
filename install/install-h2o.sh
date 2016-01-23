cd $DOTFILES/pkg
ghlatest h2o/h2o
cd h2o
cmake -DCMAKE_INSTALL_PREFIX=$DOTFILES/local/h2o -DWITH_BUNDLED_SSL=on .
make
make install
