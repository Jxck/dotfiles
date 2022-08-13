#!/usr/bin/env zsh

if [[ `uname` == "Darwin" ]]; then
  echo "install via brew"
  exit 0
fi

cd $DOTFILES/local
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
mv mkcert-v*-linux-amd64 mkcert
chmod +x mkcert
