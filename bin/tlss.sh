openssl s_server -cert $DOTFILES/keys/cert.pem -key $DOTFILES/keys/key.pem  -accept 3000 -no_dhe -no_ecdhe -debug -msg -state -tlsextdebug
