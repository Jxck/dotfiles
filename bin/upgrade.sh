update.sh

# install
cd $DOTFILES/install
./install-brotli.sh \
& ./install-diff-highlight.sh \
& ./install-git-delta.sh \
& ./install-icdiff.sh \
& ./install-peco.sh \
& ./install-tmux2.sh \
& ./install-webp.sh

# neobundle
cd $DOTFILES
git submodule foreach 'git pull origin master'
vim +NeoBundleUpdate +qall
