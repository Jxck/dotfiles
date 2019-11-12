\rm -rf $DOTFILES/pkg/quic
mkdir $DOTFILES/pkg/quic
cd $DOTFILES/pkg/quic

# openssl
git clone --depth 1 -b openssl-quic-draft-24 https://github.com/tatsuhiro-t/openssl
cd openssl
# For Linux
./config enable-tls1_3 --prefix=$PWD/build
make -j$(nproc)
make install_sw

# nghttp3
cd ..
git clone https://github.com/ngtcp2/nghttp3
cd nghttp3
autoreconf -i
./configure --prefix=$PWD/build --enable-lib-only
make -j$(nproc) check
make install

# ngtcp2
cd ..
git clone https://github.com/ngtcp2/ngtcp2
cd ngtcp2
autoreconf -i
# For Mac users who have installed libev with MacPorts, append
# ',-L/opt/local/lib' to LDFLAGS, and also pass
# CPPFLAGS="-I/opt/local/include" to ./configure.
./configure PKG_CONFIG_PATH=$PWD/../openssl/build/lib/pkgconfig:$PWD/../nghttp3/build/lib/pkgconfig LDFLAGS="-Wl,-rpath,$PWD/../openssl/build/lib"
make -j$(nproc) check
