###################
# intall rails
###################

if [ `uname` = "Linux" ]; then
  if uname -a | grep ubuntu -i >/dev/null; then
    #########
    # ubuntu
    #########
    sudo apt-get install -y \
      sqlite3 \
      libsqlite3-dev \
      mysql-client \
      libmysqlclient-dev \
  fi
fi

# install rbenv
git clone https://github.com/sstephenson/rbenv .rbenv
RBENV_PATH='export PATH=$HOME/.rbenv/bin:$PATH'
# install ruby-build
mkdir -p ~/.rbenv/plugins
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/ruby-build
# set path & init
eval $RBENV_PATH
echo $RBENV_PATH >> ~/.bashrc
rbenv init -
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
# install ruby
rbenv install 1.9.3-p194
rbenv global 1.9.3-p194
# install rails & bundler
rbenv exec gem install bundler rails
exec $shell

echo 'alias bundle-install="bundle install --path vendor/bundle"' >> ~/.bashrc
echo 'alias rails="bundle exec rails"' >> ~/.bashrc
