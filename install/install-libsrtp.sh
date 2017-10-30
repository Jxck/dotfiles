cd $DOTFILES/pkg
DEST=$DOTFILES/pkg/libsrtp
rm -rf $DEST
ghlatest cisco/libsrtp
cd $DEST
./configure --enable-debug-logging --enable-log-stdout
make
