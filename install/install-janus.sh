sudo apt install        \
  libmicrohttpd-dev     \
  libjansson-dev        \
  libssl-dev            \
  libsrtp2-dev          \
  libsofia-sip-ua-dev   \
  libglib2.0-dev        \
  libopus-dev           \
  libogg-dev            \
  libcurl4-openssl-dev  \
  liblua5.3-dev         \
  libconfig-dev         \
  pkg-config            \
  gengetopt             \
  libtool               \
  automake

DEST=$DOTFILES/pkg/janus-gateway
rm -rf $DEST
mkdir $DEST
cd $DEST

git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --prefix=$DOTFILES/local/janus-gateway
make
make install
make configs
