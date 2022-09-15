brew install wireshark

# sudo add-apt-repository ppa:wireshark-dev/stable
# sudo apt update
# sudo apt install wireshark
# sudo adduser $USER wireshark

# sudo apt install \
#   bison \
#   flex \
#   libpcap-dev \
#   libqt4-dev \
#   libgtk-3-dev \
#   libqt5svg5-dev \
#   qtbase5-dev \
#   qttools5-dev \
#   qttools5-dev-tools \
#   qtmultimedia5-dev
# 
# 
# \rm -rf $DOTFILES/pkg/wireshark
# \rm -rf $DOTFILES/local/wireshark
# 
# mkdir $DOTFILES/pkg/wireshark
# mkdir $DOTFILES/local/wireshark
# 
# cd $DOTFILES/pkg/wireshark
# TARGET=wireshark-3.1.0
# 
# # https://www.wireshark.org/download/src/all-versions/
# wget https://www.wireshark.org/download/src/all-versions/$TARGET.tar.xz
# tar xf $TARGET.tar.xz
# cd ./$TARGET
# cmake -DCMAKE_INSTALL_PREFIX=$DOTFILES/local/wireshark
# make -j$(core)
# make install
