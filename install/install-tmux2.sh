if [ `uname` = "Linux" ]; then
  sudo apt-get update
  sudo apt-get install -y \
    automake \
    pkg-config
elif [ `uname` = "Darwin" ]; then
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
