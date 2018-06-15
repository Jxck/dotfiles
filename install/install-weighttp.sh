LOCAL=$DOTFILES/local/weighttp
rm -rf $LOCAL
mkdir $LOCAL

PKG=$DOTFILES/pkg/weighttp
rm -rf $PKG
git clone https://github.com/lighttpd/weighttp $PKG
cd $PKG
./waf configure --prefix=$LOCAL
./waf build
./waf install
