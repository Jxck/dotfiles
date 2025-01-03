# Mac configuration

## show file extension
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

## Show Path
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

## Key Repeat
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 2

## Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

## Dock to left/auto-hide
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock tilesize -int 30;
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool false


## brew for desktop
brew install --cask    \
  1password            \
  audacity             \
  brave-browser        \
  caffeine             \
  contexts             \
  deepl                \
  discord              \
  figma                \
  firefox@nightly      \
  google-chrome        \
  google-chrome@canary \
  google-chrome@dev    \
  google-japanese-ime  \
  hyper                \
  microsoft-edge       \
  rectangle            \
  scroll-reverser      \
  spotify              \
  visual-studio-code   \
  xquartz              \
  zoom                 \