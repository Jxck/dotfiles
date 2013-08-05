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
  libevent-dev

#git clone https://github.com/tatsuhiro-t/spdylay.git
#cd spdyaly
#autoreconf -i
#automake
#autoconf
#./configure
#make


## nghttp
sudo apt-get install -y python-software-properties
sudo apt-get update

sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-4.7

sudo update-alternatives --list gcc
