# https://www.digicert.com/kb/ecc-csr-creation-ssl-installation-apache.htm
# CAA: 0 issue "digicert.com; cansignhttpexchanges=yes"
openssl ecparam -out sxg.key -name prime256v1 -genkey
openssl req -new -key sxg.key -sha256 -out sxg.csr
openssl req -text -in sxg.csr
