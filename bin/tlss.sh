openssl s_server \
  -keylogfile $SSLKEYLOGFILE \
  -tls1_3 \
  -key $DOTFILES/keys/privkey.pem \
  -cert $DOTFILES/keys/cert.pem \
  -accept 5000 \
  -debug \
  -msg \
  -state \
  -tlsextdebug
