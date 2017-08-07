cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/brotli
ghlatest google/brotli
cd $DOTFILES/pkg/brotli
mkdir $DOTFILES/local/brotli
cmake .. -DBUILD_SHARED_LIBS=OFF --prefix=$DOTFILES/local/brotli
make
