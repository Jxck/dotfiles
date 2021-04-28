cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/gh-cli
rm -rf $DOTFILES/local/gh-cli
git clone --depth 1 https://github.com/cli/cli.git gh-cli
cd gh-cli
mkdir $DOTFILES/local/gh-cli
make install prefix=$DOTFILES/local/gh-cli
