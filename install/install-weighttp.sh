cd /tmp
git clone https://github.com/lighttpd/weighttp
cd ./weighttp
./waf configure
./waf build
cp /tmp/weighttp/build/default/weighttp $DOTFILES/bin
