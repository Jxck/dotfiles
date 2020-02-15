cd /tmp
if [ `uname` = "Linux" ]; then
  # wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
  # sudo dpkg -i erlang-solutions_1.0_all.deb
  # sudo apt update
  # sudo apt install erlang

  sudo apt install libtinfo5 libncurses5 libwxbase3.0-0v5 libwxgtk3.0-0v5 libsctp1

  VERSION=22.2.6
  wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_$VERSION-1~ubuntu~disco_amd64.deb
  sudo dpkg -i esl-erlang_$VERSION-1~ubuntu~disco_amd64.deb
elif [ `uname` = "Darwin" ]; then
  brew update
  brew install erlang
fi
