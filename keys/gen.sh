#!/usr/bin/env zsh


# See also
# https://letsencrypt.org/docs/certificates-for-localhost/

CONFIG=$(cat << EOF
[dn]
CN=localhost
[req]
distinguished_name = dn
[EXT]
subjectAltName=DNS:localhost
keyUsage=digitalSignature
extendedKeyUsage=serverAuth
EOF
)

echo $CONFIG | color
echo "-----"

export KEYFILE="dummy.privkey.pem"
export CERTFILE="dummy.cert.pem"

openssl req                          \
        -x509                        \
        -out        $CERTFILE        \
        -keyout     $KEYFILE         \
        -newkey     rsa:2048         \
        -nodes                       \
        -sha256                      \
        -subj       '/CN=localhost'  \
        -extensions EXT              \
        -config     <(printf $CONFIG) 2>&1 | color

openssl rsa  -text -noout -in $KEYFILE | head -n 5 | color
echo "-----"
openssl x509 -text -noout -in $CERTFILE | head -n 20 | color
