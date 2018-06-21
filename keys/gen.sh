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

echo $CONFIG

openssl req                           \
        -x509                         \
        -out        cert.pem          \
        -keyout     key.pem           \
        -newkey     rsa:2048          \
        -nodes      -sha256           \
        -subj       '/CN=localhost'   \
        -extensions EXT               \
        -config     <(printf $CONFIG)

openssl x509 -text -noout -in ./cert.pem > x509.txt
