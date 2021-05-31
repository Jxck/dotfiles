###################
# intall ruby
###################

#========================
# README, update via below
# $ rbenv update
#========================

DEST=$DOTFILES/pkg/rbenv

# change rbenv root to DEST
export RBENV_ROOT=$DEST

# install rbenv
rm -rf $DEST
git clone --depth 1 https://github.com/sstephenson/rbenv $DEST

# install ruby-build
mkdir -p $DEST/plugins
git clone --depth 1 https://github.com/sstephenson/ruby-build $DEST/plugins/ruby-build

# install rbenv-update
mkdir -p $DEST/plugins
git clone --depth 1 https://github.com/rkh/rbenv-update.git $DEST/plugins/rbenv-update

$DEST/bin/rbenv install 3.0.0
$DEST/bin/rbenv global 3.0.0
# rbenv exec gem install -N bundler rails
