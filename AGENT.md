# dotfiles

Jxck の個人 dotfiles リポジトリ。


## Language

- 日本語で丁寧に応答する
- コード内のコメントは日本語で書く


## 環境

- OS: macOS / ubuntu
- Shell: zsh
- Editor: Visual Studio / vim
- Terminal Multiplexer: tmux
- Package Management: Homebrew
- Tool Version Management: mise
- GNU coreutils を Homebrew で導入して使用


## Git

- commit は SSH 鍵による GPG 署名付き
- commit message は英語で書く
- pull は rebase (マージコミットを作らない)
- push は force-with-lease
- pager は delta (Dracula テーマ)


## Coding Style

- インデントはスペース 2 つ
- 末尾の空白は削除する
- ファイル末尾に改行を入れる
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