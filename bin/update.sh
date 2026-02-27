#!/usr/bin/env zsh

if [[ $(uname) == "Linux" ]]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt clean
  sudo apt full-upgrade -y
  do-release-upgrade -c
  fwupdmgr get-upgrades
fi

# brew (mise 自体も brew で管理しているので先に実行)
echo "=== brew ==="
brew update
brew upgrade

# mise (brew の後に実行)
echo "=== mise ==="
mise completion zsh > $DOTFILES/zsh/mise.completion.zsh
mise upgrade
mise prune -y

# git fetch を並行実行
if [[ -d $DEV/jxck.io ]]; then
  (
    echo "=== fetch jxck.io ==="
    cd $DEV/jxck.io
    git f
    npm ci
  ) &
fi

if [[ -d $DOTFILES ]]; then
  (
    echo "=== fetch dotfiles ==="
    cd $DOTFILES
    git f
  ) &
fi

wait
echo "=== done ==="
