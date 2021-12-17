rm -rf *pm

sudo cp /etc/letsencrypt/live/localhost.jxck.io/cert.pem      ./localhost.jxck.io.cert.pem
sudo cp /etc/letsencrypt/live/localhost.jxck.io/chain.pem     ./localhost.jxck.io.chain.pem
sudo cp /etc/letsencrypt/live/localhost.jxck.io/fullchain.pem ./localhost.jxck.io.fullchain.pem
sudo cp /etc/letsencrypt/live/localhost.jxck.io/privkey.pem   ./localhost.jxck.io.privkey.pem

sudo cp /etc/letsencrypt/live/jxck.dev/cert.pem      ./jxck.dev.cert.pem
sudo cp /etc/letsencrypt/live/jxck.dev/chain.pem     ./jxck.dev.chain.pem
sudo cp /etc/letsencrypt/live/jxck.dev/fullchain.pem ./jxck.dev.fullchain.pem
sudo cp /etc/letsencrypt/live/jxck.dev/privkey.pem   ./jxck.dev.privkey.pem

sudo chown jxck:jxck ./*pem
