tap "homebrew/bundle"
tap "manaflow-ai/cmux"

# Shell
brew "tmux"
brew "vim"

# GNU Coreutils
brew "coreutils"  # ls, cat etc
brew "diffutils"  # diff util
brew "findutils"  # find, xargs, locate
brew "gnu-sed"    # sed
brew "gnu-tar"    # tar
brew "gnu-time"   # time
brew "grep"       # grep
brew "gzip"       # gzip

# Build
brew "autoconf"   # configure generator
brew "cmake"      # cmake
brew "ctags"      # source indexing
brew "pkg-config" # compile/link

# Devtool
brew "gh"         # GitHub CLI
brew "git"        # Git
brew "git-delta"  # Syntax Highlight / Pager
brew "mise"       # Tool Versioning

# CLI
brew "calc"       # 電卓
brew "fd"         # find 代替
brew "fzf"        # peco 代替
brew "jq"         # JSON プロセッサ
brew "ripgrep"    # grep 代替
brew "sd"         # sed 代替
brew "tree"       # ディレクトリ表示
brew "wget"       # HTTP

# System
brew "duf"        # ディスク使用量ビューア
brew "dust"       # du 代替
brew "procs"      # ps 代替

# メディア/圧縮
brew "brotli"     # Brotli 圧縮
brew "ffmpeg"     # 動画/音声変換
brew "gifsicle"   # GIF 最適化
brew "jpeg"       # JPEG ライブラリ
brew "libavif"    # AVIF エンコーダ (avifenc)
brew "mozjpeg"    # JPEG 最適化 (jpegtran)
brew "nkf"        # 日本語エンコーディング変換
brew "optipng"    # PNG 最適化
brew "webp"       # WebP 画像フォーマット

# セキュリティ
brew "gnupg"         # GNU Privacy Guard
cask "1password-cli" # 1Password CLI

# GUI アプリ
cask "xquartz"    # macOS 用 X11 サーバ
cask "swiftbar"   # macOS メニューバーカスタマイザ

# macOS 専用
if OS.mac?
  brew "pam-reattach"  # tmux 内で sudo に Touch ID を使用
  cask "alt-tab"       # Window Switcher
  cask "cmux"          # tmux session manager
  cask "linearmouse"   # マウスのリバース/スクロールのスムーズ
  cask "raycast"       # Launcher

  cask "google-chrome@beta"
end
