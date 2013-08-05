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

### install gcc4.7
# http://charette.no-ip.com:81/programming/2011-12-24_GCCv47/
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install -y gcc-4.7 g++-4.7
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
sudo update-alternatives --list gcc
sudo update-alternatives --config gcc

#git clone https://github.com/tatsuhiro-t/nghttp2.git
#cd nghttp2
#autoreconf -i
#automake
#autoconf
#./configure
#make
