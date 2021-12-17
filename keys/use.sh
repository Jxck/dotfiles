rm -f cert.pem
rm -f chain.pem
rm -f fullchain.pem
rm -f privkey.pem

if [[ $1 == "jxck.dev" ]]; then
  echo use jxck.dev
  ln -s jxck.dev.cert.pem                ./cert.pem
  ln -s jxck.dev.chain.pem               ./chain.pem
  ln -s jxck.dev.fullchain.pem           ./fullchain.pem
  ln -s jxck.dev.privkey.pem             ./privkey.pem
fi

if [[ $1 == "localhost.jxck.io" ]]; then
  echo use localhost.jxck.io
  ln -s localhost.jxck.io.cert.pem       ./cert.pem
  ln -s localhost.jxck.io.chain.pem      ./chain.pem
  ln -s localhost.jxck.io.fullchain.pem  ./fullchain.pem
  ln -s localhost.jxck.io.privkey.pem    ./privkey.pem
fi
