# Mac configuration
# System Settings の並び順に合わせる


###########################
# Appearance
###########################

# Appearance: Dark
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"


###########################
# Desktop & Dock
###########################

# Size: Small (30)
defaults write com.apple.dock tilesize -int 30

# Magnification: Off
defaults write com.apple.dock magnification -bool false

# Position on screen: Left
defaults write com.apple.dock orientation -string "left"

# Automatically hide and show the Dock: On
defaults write com.apple.dock autohide -bool true

# Hot Corners > Bottom Right: Cmd + Lock Screen
defaults write com.apple.dock wvous-br-corner -int 13
defaults write com.apple.dock wvous-br-modifier -int 1048576
# Hot Corners > Top Right: Off
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-tr-modifier -int 0


###########################
# Keyboard
###########################

# Key repeat rate: Fast (2)
defaults write -g KeyRepeat -int 2

# Delay until repeat: Short (25)
defaults write -g InitialKeyRepeat -int 25

# Keyboard navigation: On
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Keyboard Shortcuts > Spotlight > Show Spotlight search: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '
<dict>
  <key>enabled</key><false/>
  <key>value</key>
  <dict>
    <key>parameters</key>
    <array>
      <integer>32</integer>
      <integer>49</integer>
      <integer>1572864</integer>
    </array>
    <key>type</key><string>standard</string>
  </dict>
</dict>'
# Keyboard Shortcuts > Spotlight > Show Finder search window: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 '
<dict>
  <key>enabled</key><false/>
  <key>value</key>
  <dict>
    <key>parameters</key>
    <array>
      <integer>65535</integer>
      <integer>49</integer>
      <integer>1572864</integer>
    </array>
    <key>type</key><string>standard</string>
  </dict>
</dict>'

## Text Input > Input Sources > Edit...
# Correct spelling automatically: Off
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Capitalize words automatically: Off
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Add period with double-space: Off
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Use smart quotes and dashes: Off
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

###########################
# Mouse
###########################

# Tracking speed (1.5, default: 1.0)
defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.5

# Double-Click Speed (0.5, default: 0.5)
defaults write NSGlobalDomain com.apple.mouse.doubleClickThreshold -float 0.5

# Scrolling Speed (1.7, default: 0.3125)
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 1.7


###########################
# Trackpad
###########################

## Point & Click > Tap to click: On
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true


###########################
# Finder (Finder > Settings)
###########################

## General > Show these items on the desktop:
# Hard disks: Off
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
# External disks: Off
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
# CDs, DVDs, and iPods: Off
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
# Connected servers: Off
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

## General > New Finder windows show: Downloads
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

## Advanced > Show all filename extensions: On
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

## Show hidden files (Cmd+Shift+.)
defaults write com.apple.finder AppleShowAllFiles -bool true

## Advanced > Remove items from the Trash after 30 days: On
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

## Advanced > Keep folders on top > In windows when sorting by name: On
defaults write com.apple.finder _FXSortFoldersFirst -bool true

## Advanced > When performing a search: Search the Current Folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

## View > Show Sidebar: On (Opt+Cmd+S)
defaults write com.apple.finder ShowSidebar -bool true

## View > Show Path Bar: On
defaults write com.apple.finder ShowPathbar -bool true

## View > Show Status Bar: On
defaults write com.apple.finder ShowStatusBar -bool true

## View > as List (default view style)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"


###########################
# Apply changes
###########################
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u


###########################
# brew install --cask
###########################

# brew install --cask    \
#   1password            \
#   audacity             \
#   caffeine             \
#   contexts             \
#   deepl                \
#   discord              \
#   figma                \
#   hyper                \
#   kindle               \
#   microsoft-edge       \
#   raycast              \
#   linearmouse          \
#   spotify              \
#   visual-studio-code   \
#   xquartz              \
#   zoom                 \

# brew install --cask    \
#   arc                  \
#   brave-browser        \
#   firefox              \
#   firefox@nightly      \
#   google-chrome        \
#   google-chrome@canary \
#   google-chrome@dev    \
#   google-japanese-ime  \
