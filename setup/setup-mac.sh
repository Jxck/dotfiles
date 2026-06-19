# Mac configuration
# System Settings の並び順に合わせる


###########################
# Appearance
###########################

# Appearance: Dark
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"


###########################
# Language & Region
###########################

# Preferred Languages: English(日本) > 日本語 > English の順
defaults write NSGlobalDomain AppleLanguages -array "en-JP" "ja-JP" "en"
# Region: 日本 (英語ベース)
defaults write NSGlobalDomain AppleLocale -string "en_JP"


###########################
# Accessibility
###########################

## Zoom
# Use scroll gesture with modifier keys to zoom: On
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
# Modifier key for scroll gesture: Command (1048576)
defaults write com.apple.universalaccess closeViewScrollWheelModifiersInt -int 1048576


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
# Hot Corners > Top Left: Off
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tl-modifier -int 0
# Hot Corners > Bottom Left: Off
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-bl-modifier -int 0

# Wallpaper: setup/wallpaper.jpg を全デスクトップに設定
# setup-mac.sh 単体実行でも動くよう DOTFILES をフォールバック
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
osascript -e "tell application \"System Events\" to set picture of every desktop to \"$DOTFILES/setup/wallpaper.jpg\""

###########################
# Control Center (メニューバー)
###########################

# メニューバーに常時表示する項目 (コード 18 = Show in Menu Bar)
# モジュールの表示コードは currentHost ドメインに入る
defaults -currentHost write com.apple.controlcenter Bluetooth -int 18
defaults -currentHost write com.apple.controlcenter Sound -int 18


###########################
# Battery
###########################

# Low Power Mode: Never (battery と AC 両方を off)
# defaults では扱えないため pmset を使う (要 sudo)
sudo pmset -a lowpowermode 0


###########################
# Keyboard
###########################

# Key repeat rate: Fast (2)
defaults write -g KeyRepeat -int 2

# Delay until repeat: Short (25)
defaults write -g InitialKeyRepeat -int 25

# Keyboard navigation: On
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Modifier Keys > Caps Lock を Control に変更
# Src 0x700000039 (Caps Lock) -> Dst 0x7000000E0 (Left Control)
# キーは <vendorID>-<productID>-0 のデバイス固有。0-0-0 は汎用フォールバック。
# 外付けで効かない個体は System Settings で一度選び直すとそのデバイスのエントリが作られる
defaults -currentHost write -g com.apple.keyboard.modifiermapping.0-0-0 -array '
<dict>
  <key>HIDKeyboardModifierMappingDst</key><integer>30064771300</integer>
  <key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer>
</dict>'

# Raycast を使うため Spotlight のショートカットをオフにする
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

## Point & Click > Tracking speed: Fast 寄り (2, max: 3)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2

## More Gestures > Look up & data detectors (3本指タップ): Off
# 内蔵トラックパッドと Magic Trackpad (Bluetooth) の両ドメインに書く
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0


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
# SwiftBar
###########################

# プラグインフォルダをこのリポジトリの swiftbar/ に向ける (DOTFILES は Wallpaper で定義済み)
defaults write com.ameba.SwiftBar PluginDirectory -string "$DOTFILES/swiftbar"
# プラグインに実行権限を自動付与
defaults write com.ameba.SwiftBar MakePluginExecutable -bool true


###########################
# Apply changes
###########################
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# activateSettings では反映されないアプリを再起動して即時反映する
killall Dock
killall Finder
killall SystemUIServer
killall ControlCenter 2>/dev/null
