###################
# intall ruby
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
      libmysqlclient-dev
  fi
fi

# install rbenv
rm -rf ~/.rbenv
git clone https://github.com/sstephenson/rbenv ~/.rbenv

# install ruby-build
mkdir -p ~/.rbenv/plugins
git clone https://github.com/sstephenson/ruby-build ~/.rbenv/plugins/ruby-build

# rbenv install 2.2
# rbenv global 2.2
# rbenv exec gem install bundler rails
