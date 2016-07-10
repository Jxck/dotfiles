cd $DOTFILES/pkg
wget https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz
tar zxvf tmux-2.2.tar.gz
rm tmux-2.2.tar.gz
cd tmux-2.2
./configure --prefix=$DOTFILES/local/tmux
make
make install
