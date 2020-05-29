if [ `uname` = "Darwin" ]; then
  export HOMEBREW_INSTALL_CLEANUP=1 brew cleanup
  cd $(brew --repo)
  git fetch
  git reset --hard origin/master
  brew update
fi

if [ `uname` = "Linux" ]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt clean
fi

# rbenv
rbenv update

# neobundle
cd $DOTFILES
git submodule foreach 'git pull origin master'
vim +NeoBundleUpdate +qall

# install
cd $DOTFILES/install
./install-brotli.sh \
& ./install-diff-highlight.sh \
& ./install-git-delta.sh \
& ./install-icdiff.sh \
& ./install-peco.sh \
& ./install-tmux2.sh \
& ./install-webp.sh
