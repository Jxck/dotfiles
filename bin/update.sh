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
brew bundle
brew upgrade
brew autoremove
brew cleanup

# zshrc で使うキャッシュファイルの再生成
echo "=== zsh cache ==="
if [[ $(uname) == "Darwin" ]]; then
  brew shellenv > $DOTFILES/zsh/brew.shellenv.mac.zsh
elif [[ $(uname) == "Linux" ]]; then
  brew shellenv > $DOTFILES/zsh/brew.shellenv.linux.zsh
fi
op completion zsh > $DOTFILES/zsh/op.completion.zsh

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
