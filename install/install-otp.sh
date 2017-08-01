cd $DOTFILES/pkg
curl -LO http://erlang.org/download/otp_src_20.0.tar.gz
tar zxvf otp_src_20.0.tar.gz
cd otp_src_20.0
./configure --prefix=$DOTFILES/local/otp
make
make install
