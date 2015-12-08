DEST=$DOTFILES/pkg/weighttp
rm -rf $DEST
git clone https://github.com/lighttpd/weighttp $DEST
cd $DEST
./waf configure
./waf build
