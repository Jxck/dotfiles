export VERSION=3.2.0 # 1.1.0
cd $DOTFILES/pkg
curl -LO https://www.openssl.org/source/openssl-${VERSION}.tar.gz
tar zxvf openssl-${VERSION}.tar.gz
cd openssl-${VERSION}
./config --prefix=$DOTFILES/local/openssl
make
make install
