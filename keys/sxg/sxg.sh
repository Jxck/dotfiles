# https://www.digicert.com/kb/ecc-csr-creation-ssl-installation-apache.htm
# CAA: 0 issue "digicert.com; cansignhttpexchanges=yes"
## openssl ecparam -out  labs.jxck.io.sxg.key -name prime256v1 -genkey
## openssl req -new -key labs.jxck.io.sxg.key -sha256 -out labs.jxck.io.sxg.csr -subj '/CN=labs.jxck.io'
## openssl req -text -in labs.jxck.io.sxg.csr
##
## chmod -w labs.jxck.io.*
## sudo chown root:root labs.jxck.io.*
