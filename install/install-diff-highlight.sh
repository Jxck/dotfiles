DEST=$DOTFILES/local/diff-highlight

\rm -rf $DEST
mkdir $DEST

cd $DOTFILES/pkg
\rm -rf $DOTFILES/pkg/git
git clone --depth 1 https://github.com/git/git

cd git/contrib/diff-highlight
make

cp diff-highlight $DEST/
chmod +x $DEST/diff-highlight
\rm -rf $DOTFILES/pkg/git
