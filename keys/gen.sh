#!/usr/bin/env zsh


# See also
# https://letsencrypt.org/docs/certificates-for-localhost/


export COMMON="a.example"
export SAN="DNS:a.example, DNS:b.example"
export KEYFILE="dummy.privkey.pem"
export CERTFILE="dummy.cert.pem"


CONFIG=$(cat << EOF
[dn]
CN=$COMMON
[EXT]
subjectAltName=$SAN
keyUsage=digitalSignature
extendedKeyUsage=serverAuth
EOF
)

echo $CONFIG | color
echo "-----"

# https://www.openssl.org/docs/man3.0/man1/openssl-req.html
openssl req                          \
        -x509                        \
        -out        $CERTFILE        \
        -keyout     $KEYFILE         \
        -newkey     rsa:2048         \
        -nodes                       \
        -sha256                      \
        -subj       "/CN=$COMMON"  \
        -extensions EXT              \
        -config     <(printf $CONFIG) 2>&1 | color

openssl rsa  -text -noout -in $KEYFILE | head -n 5 | color
echo "-----"
openssl x509 -text -noout -in $CERTFILE | color
