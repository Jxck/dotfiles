cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/brotli
rm -rf $DOTFILES/local/brotli
ghlatest google/brotli
cd $DOTFILES/pkg/brotli
mkdir $DOTFILES/local/brotli
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$DOTFILES/local/brotli
cmake --build . --config Release --target install
