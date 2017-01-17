cd /tmp
if [ `uname` = "Linux" ]; then
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
  sudo dpkg -i erlang-solutions_1.0_all.deb
  sudo apt-get update
  sudo apt-get install erlang
elif [ `uname` = "Darwin" ]; then
  brew update
  brew install erlang
fi
