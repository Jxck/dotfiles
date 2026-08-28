#!/usr/bin/env zsh

# certbot は証明書を管理する Linux ホストでのみ使うため
# Brewfile には入れず、このスクリプトで個別にインストールする
#
# brew 版は sudo 実行時に Cellar 内へ root 所有の __pycache__ を生成し
# brew cleanup が Permission denied で失敗するため apt を使う
# (apt 版はシステムの /usr/bin/python3 で動き、依存も python3-* のみ)

if [[ `uname` == "Darwin" ]]; then
  echo "certbot は Linux ホストでのみ使う想定 (mac では未対応)"
  exit 0
fi

sudo apt install -y certbot
