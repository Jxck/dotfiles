confpath="$HOME/dotfiles/conf"

for f in `\ls -A $confpath`
do
  echo rm  ~/$f
  rm  ~/$f
done

cat << EOS > ~/.zprofile
unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY
unset all_proxy
unset ALL_PROXY
unset no_proxy
unset NO_PROXY
unset SOCKS5_USER
unset SOCKS5_PASSWD
EOS
