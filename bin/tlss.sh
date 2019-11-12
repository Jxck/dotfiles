openssl s_server -cert $DOTFILES/keys/cert.pem -key $DOTFILES/keys/privkey.pem  -accept 5000 -debug -msg -state -tlsextdebug -tls1_3
