if [[ `uname` == "Darwin" ]]; then
  echo "install via brew"
  exit 0
fi

if [[ `uname` == "Linux" ]]; then
  sudo apt update
  sudo apt install -y \
    automake \
    pkg-config
elif [[ `uname` == "Darwin" ]]; then
  brew install \
    automake \
    pkg-config
fi

cd $DOTFILES/pkg

rm -rf $DOTFILES/pkg/tmux
ghlatest tmux/tmux
cd $DOTFILES/pkg/tmux
sh autogen.sh

./configure --prefix=$DOTFILES/local/tmux
rm -rf $DOTFILES/local/tmux
make
make install
