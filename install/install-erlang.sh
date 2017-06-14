cd /tmp
if [ `uname` = "Linux" ]; then
  # wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
  # sudo dpkg -i erlang-solutions_1.0_all.deb
  # sudo apt-get update
  # sudo apt-get install erlang
  wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_19.3.6-1~ubuntu~xenial_amd64.deb
  sudo dpkg -i esl-erlang_19.3.6-1~ubuntu~xenial_amd64.deb
elif [ `uname` = "Darwin" ]; then
  brew update
  brew install erlang
fi
