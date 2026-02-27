# dotfiles

Jxck の個人 dotfiles リポジトリ。

@CLAUDE.global.md


## Coding Style

- 基本は zsh 向け shell script
- もしくは ruby script


## ディレクトリ構成

- bin/: カスタムスクリプト
- zsh/: zsh のモジュール別設定 (mac.zsh, common.zsh, fzf.zsh 等)
- install/: ビルド・インストールスクリプト
- conf/: 各種ツールの設定ファイル
- tmux/: OS 別 tmux 設定
- keys/: TLS 証明書・SSH 鍵 (読まない・変更しない)


## 主要ファイル

- .zshrc: シェル設定のエントリポイント
- .gitconfig: git 設定 (delta, GPG 署名, エイリアス)
- .tmux.conf: tmux 設定 (prefix は C-s, vi モード)
- .vimrc: vim 設定
- .mise.toml: ツールバージョン管理 (node, deno, bun, go, rust 等)
- Brewfile: Homebrew パッケージ一覧