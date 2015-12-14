cd $DOTFILES/pkg
wget https://github.com/tmux/tmux/releases/download/2.1/tmux-2.1.tar.gz
tar zxvf tmux-2.1.tar.gz
cd tmux-2.1
./configure
make
sudo make install
