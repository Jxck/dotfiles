openssl s_client \
  -keylogfile $SSLKEYLOGFILE \
  -tls1_3 \
  -connect localhost.jxck.io:5000 \
  -no_ticket \
  -msg
