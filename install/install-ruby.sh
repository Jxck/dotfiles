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

$DEST/bin/rbenv install 3.1.0
$DEST/bin/rbenv global 3.1.0
# rbenv exec gem install -N bundler rails


# zsh
# if [[ -d "$DOTFILES/pkg/rbenv/bin" ]]; then
#   VERSION=3.1.0
#   export RBENV_ROOT=$DOTFILES/pkg/rbenv
#   addToPath $DOTFILES/pkg/rbenv/bin
#   addToPath $DOTFILES/pkg/rbenv/shims
#   rbenv global $VERSION
#   # eval "$(rbenv init -)"
#   echo "rbenv use:" $VERSION
# fi