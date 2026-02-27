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
brew autoremove
brew cleanup

# mise (brew の後に実行)
echo "=== mise ==="
mise completion zsh > $DOTFILES/zsh/mise.completion.zsh
mise upgrade --bump
mise prune -y

if [[ -d $DOTFILES ]]; then
  (
    echo "=== fetch dotfiles ==="
    cd $DOTFILES
    git f
  )
fi

if [[ -d $DEV/jxck.io ]]; then
  (
    echo "=== fetch jxck.io ==="
    cd $DEV/jxck.io
    git f
    npm ci
  )
fi

echo "=== done ==="
