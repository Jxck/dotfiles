HOST=jxck.io

CERT=/tmp/$HOST.crt

openssl s_client -connect $HOST:443 </dev/null 2>/dev/null > $CERT

OCSP=`openssl x509 -ocsp_uri -noout < $CERT`

SERIAL=`openssl x509 -serial -noout < $CERT | sed 's/serial=//'`

SERIAL_DEC=$(echo "ibase=16;obase=0A;$SERIAL"|bc)

echo $OCSP

openssl ocsp \
  -noverify \
  -no_nonce \
  -issuer $CERT \
  -serial $SERIAL_DEC \
  -url $OCSP \
  -text | color 'Cert Status'
