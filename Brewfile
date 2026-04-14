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
brew "git-tools"  # Includes git-restore-mtime
brew "mise"       # Tool Versioning

# CLI
brew "calc"       # 電卓
brew "fd"         # find 代替
brew "fzf"        # peco 代替
brew "jq"         # JSON プロセッサ
brew "parallel"   # GNU Parallel
brew "ripgrep"    # grep 代替
brew "sd"         # sed 代替
brew "sponge"     # stdin を吸って同一ファイルに書き戻し
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
brew "pngquant"   # PNG 量子化
brew "webp"       # WebP 画像フォーマット
brew "zopfli"     # Zopfli 圧縮
brew "zstd"       # Zstd 圧縮

# セキュリティ
brew "certbot"         # HTTPS Certificate
brew "gnupg"           # GNU Privacy Guard
cask "1password-cli"   # 1Password CLI

# AI
brew "whisper-cpp" # Whisper

# Other
brew "libdivsufsort" # brotli の dictionary-generator 用

# macOS 専用
if OS.mac?
  brew "pam-reattach"  # tmux 内で sudo に Touch ID を使用
  cask "alt-tab"       # Window Switcher
  cask "linearmouse"   # マウスのリバース/スクロールのスムーズ
  cask "raycast"       # Launcher
  cask "swiftbar"      # macOS メニューバーカスタマイザ
  cask "xquartz"       # macOS 用 X11 サーバ
  cask "commander-one" # ファイラー

  cask "cloudflare-warp" # WARP
  cask "google-chrome@beta"

  tap "manaflow-ai/cmux" # tmux session manager
  cask "cmux"
end
