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

# cd $HOME
# rm -rf .spdylay
# git clone https://github.com/tatsuhiro-t/spdylay.git .spdylay
# cd .spdylay
# autoreconf -i
# automake
# autoconf
# ./configure
# make

cd $HOME
rm -rf .nghttp2
git clone https://github.com/tatsuhiro-t/nghttp2 .nghttp2
cd .nghttp2
autoreconf -i
automake
autoconf
./configure
make
