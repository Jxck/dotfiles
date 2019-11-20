rm -rf *pm
sudo cp /etc/letsencrypt/live/localhost.jxck.io/cert.pem ./cert.pem
sudo cp /etc/letsencrypt/live/localhost.jxck.io/chain.pem ./chain.pem
sudo cp /etc/letsencrypt/live/localhost.jxck.io/fullchain.pem ./fullchain.pem
sudo cp /etc/letsencrypt/live/localhost.jxck.io/privkey.pem ./privkey.pem
sudo chown jxck:jxck ./*pem
