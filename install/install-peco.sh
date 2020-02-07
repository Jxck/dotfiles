if [ `uname` = "Darwin" ]; then
  echo "install via brew"
  exit(0)
fi

rm -rf $DOTFILES/local/peco
ghbin peco/peco # move into pkg
mv $DOTFILES/pkg/peco $DOTFILES/local/peco
