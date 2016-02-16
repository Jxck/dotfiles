##########################
# intall spdylay & nghttp
##########################
sudo apt-get install -y \
  make                  \
  binutils              \
  autoconf              \
  automake              \
  autotools-dev         \
  libtool               \
  pkg-config            \
  zlib1g-dev            \
  libcunit1-dev         \
  libssl-dev            \
  libxml2-dev           \
  libev-dev             \
  libevent-dev          \
  libjansson-dev        \
  libjemalloc-dev       \
  cython                \
  python3.4-dev         \
  python-setuptools

# DEST=$DOTFILES/pkg/spdylay
# rm -rf $DEST
# git clone https://github.com/tatsuhiro-t/spdylay $DEST
# cd $DEST
# autoreconf -i
# automake
# autoconf
# ./configure
# make

cd $DOTFILES/pkg
DEST=$DOTFILES/pkg/nghttp2
rm -rf $DEST
git clone https://github.com/tatsuhiro-t/nghttp2 $DEST
cd $DEST
autoreconf -i
automake
autoconf
./configure --prefix=$DOTFILES/local/nghttp2 --disable-python-bindings
make
make install
