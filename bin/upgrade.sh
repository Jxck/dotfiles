update.sh

# install
cd $DOTFILES/install
./install-brotli.sh \
& ./install-diff-highlight.sh \
& ./install-git-delta.sh

wait

# neobundle
cd $DOTFILES
git submodule foreach 'git pull origin master'
vim +NeoBundleUpdate +qall
