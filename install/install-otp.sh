cd $DOTFILES/pkg
curl -LO http://erlang.org/download/otp_src_19.3.tar.gz
tar zxvf otp_src_19.3.tar.gz
cd otp_src_19.3
./configure --prefix=$DOTFILES/local/otp
make
make install
