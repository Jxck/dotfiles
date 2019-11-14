openssl s_server \
  -keylogfile $SSLKEYLOGFILE \
  -dtls1_2 \
  -key $DOTFILES/keys/privkey.pem \
  -cert $DOTFILES/keys/cert.pem \
  -accept 4444
