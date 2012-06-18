###################
# common
###################
alias ls='ls -la --col'


###################
# distoribute
###################
if [ `uname` = "Linux" ]; then
  if uname -a | grep ubuntu -i >/dev/null; then
    #########
    # ubuntu
    #########
    sudo apt-get install \
      build-essential \
      libssl-dev \
      libreadline6-dev \
      libxml2-dev \
      libxslt1-dev \
      sqlite3 \
      libsqlite3-dev \
      libsqlite3-ruby \
      tree \
      xsel \
      tmux \
      vim-gnome \
      git-core \
      zsh \

  else
    #########
    # cent
    #########

    # JST time
    sudo cp /usr/share/zoneinfo/Japan /etc/localtime
    # package for build
    sudo yum install -y git gcc-c++ openssl-devel make
  fi
fi

###################
# intall node.js
###################

# install nodebrew
wget https://raw.github.com/hokaccha/nodebrew/master/nodebrew
perl nodebrew setup
echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> ~/.bashrc
. ~/.bashrc
# install node
nodebrew install v0.6.11
nodebrew use v0.6.11

###################
# intall rails
###################

# install rbenv
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
. ~/.bashrc
# install ruby-build
mkdir -p ~/.rbenv/plugins
cd ~/.rbenv/plugins
git clone git://github.com/sstephenson/ruby-build.git
# install ruby
rbenv install 1.9.3-p194
rbenv global 1.9.3-p194
# install rails & bundler
rbenv exec gem install bundler rails
exec $shell
alias bundle-install = "bundle install --path vendor/bundle"
alias rails = "bundle exec rails"

