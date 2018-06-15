DEST=$DOTFILES/local/depot_tools
rm -rf $DEST
cd $DOTFILES/local
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
