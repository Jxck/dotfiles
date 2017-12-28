DEST=$DOTFILES/pkg/git

cd $DOTFILES/pkg
rm -rf $DEST
git clone https://github.com/git/git #ghlatest git/git

cd git/contrib/diff-highlight
make
cp diff-highlight $DOTFILES/bin/diff-highlight
chmod +x $DOTFILES/bin/diff-highlight
rm -rf git
