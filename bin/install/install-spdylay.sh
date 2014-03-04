sudo apt-get install -y \
  autoconf              \
  automake              \
  autotools-dev         \
  libtool               \
  pkg-config            \
  zlib1g-dev            \
  libcunit1-dev         \
  libssl-dev            \
  libxml2-dev           \
  libevent-dev          \
  libjansson-dev

git clone https://github.com/tatsuhiro-t/spdylay.git .spdylay
cd .spdylay
autoreconf -i
automake
autoconf
./configure
make

git clone https://github.com/tatsuhiro-t/nghttp2.git .nghttp2
cd .nghttp2
autoreconf -i
automake
autoconf
./configure
make
