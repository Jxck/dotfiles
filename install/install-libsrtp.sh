PKG=$DOTFILES/pkg/libsrtp
LOCAL=$DOTFILES/local/libsrtp
rm -rf $PKG
rm -rf $LOCAL

cd $DOTFILES/pkg
ghlatest cisco/libsrtp
cd $PKG
./configure --enable-debug-logging --enable-log-stdout -prefix=$DOTFILES/local/libsrtp
make
make install

mv $PKG/test $LOCAL/
