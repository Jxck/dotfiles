cd $DOTFILES/pkg
curl -LO https://www.openssl.org/source/openssl-1.1.0.tar.gz
tar zxvf openssl-1.1.0.tar.gz
cd openssl-1.1.0
./config --prefix=$DOTFILES/local/openssl
make
make install
