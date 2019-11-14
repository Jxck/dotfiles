openssl s_client \
  -keylogfile $SSLKEYLOGFILE \
  -dtls1_2 \
  -connect localhost.jxck.io:4444 \
  -no_ticket \
  -msg \
