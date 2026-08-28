#!/usr/bin/env zsh

# certbot は証明書を管理する Linux ホストでのみ使うため
# Brewfile には入れず、このスクリプトで個別にインストールする
#
# 導入元は snap (2026-08-28 決定。mozaic.fm の plan 20260828-1624 参照):
# - brew 版は sudo 実行時に Cellar 内へ root 所有の __pycache__ を生成し
#   brew cleanup が Permission denied で失敗する
# - apt 版は古い (Ubuntu 24.04 で 2.9.0)。ACME profile (--preferred-profile) に
#   非対応で、shortlived profile の renewal conf を維持できない
# - snap 版は root 管理領域 (/snap) に住むので root 実行が安全で、
#   自動 refresh により版落ちも再発しない (Ubuntu での certbot 公式推奨経路)
#
# dns-cloudflare plugin も一緒に入れる (renewal conf の authenticator が要求する)。
# trust-plugin-with-root は plugin より先に設定する (逆順だと接続されない)。
# binary は /snap/bin/certbot になる。systemd unit や Makefile からは絶対 path で呼ぶ

if [[ `uname` == "Darwin" ]]; then
  echo "certbot は Linux ホストでのみ使う想定 (mac では未対応)"
  exit 0
fi

if dpkg -s certbot > /dev/null 2>&1; then
  echo "apt 版 certbot が残っている。/usr/bin/certbot が PATH で snap 版を隠すので先に削除する:"
  echo "  sudo apt remove certbot python3-certbot"
  exit 1
fi

sudo snap install --classic certbot
sudo snap set certbot trust-plugin-with-root=ok
sudo snap install certbot-dns-cloudflare
