#!/usr/bin/env zsh

if [[ `uname` == "Darwin" ]]; then
  brew install --cask google-cloud-sdk
fi

if [[ `uname` == "Linux" ]]; then
  # これだと入れた後エラーになる
  # sudo apt install apt-transport-https ca-certificates gnupg
  # echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  # curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  # sudo apt update
  # sudo apt install google-cloud-sdk

  rm -rf $DOTFILES/pkg/google-cloud-sdk
  cd $DOTFILES/pkg
  curl -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-308.0.0-linux-x86_64.tar.gz
  tar zxvf google-cloud-sdk.tar.gz google-cloud-sdk
  cd $DOTFILES/pkg/google-cloud-sdk
  ./install.sh
fi
