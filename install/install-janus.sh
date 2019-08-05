#sudo apt install        \
#  libmicrohttpd-dev     \
#  libjansson-dev        \
#  libssl-dev            \
#  libsrtp2-dev          \
#  libsofia-sip-ua-dev   \
#  libglib2.0-dev        \
#  libopus-dev           \
#  libogg-dev            \
#  libcurl4-openssl-dev  \
#  liblua5.3-dev         \
#  libconfig-dev         \
#  libnice-dev           \
#  pkg-config            \
#  gengetopt             \
#  libtool               \
#  automake


LOCAL=$DOTFILES/local/janus-gateway
\rm -rf $LOCAL


PKG=$DOTFILES/pkg/janus-gateway
#rm -rf $PKG
#mkdir $PKG
cd $PKG


#git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --prefix=LOCAL
make
make install
make configs
