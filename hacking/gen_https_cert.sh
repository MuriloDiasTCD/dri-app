#!/bin/bash
# https://rossta.net/blog/local-ssl-for-rails-5.html

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
name=localhost.$(whoami)
# name=localhost
# generate cert and key in config/ssl
openssl req \
  -new \
  -newkey rsa:2048 \
  -sha256 \
  -days 3650 \
  -nodes \
  -x509 \
  -keyout $SCRIPTPATH/../config/ssl/$name.key \
  -out $SCRIPTPATH/../config/ssl/$name.crt \
  -config <(cat <<-EOF
  [req]
  distinguished_name = req_distinguished_name
  x509_extensions = v3_req
  prompt = no
  [req_distinguished_name]
  CN = $name
  [v3_req]
  keyUsage = keyEncipherment, dataEncipherment
  extendedKeyUsage = serverAuth
  subjectAltName = @alt_names
  [alt_names]
  DNS.1 = $name
  DNS.2 = *.$name
EOF
)

# copy cert file to local share to trust it
sudo cp "$SCRIPTPATH/../config/ssl/$name.crt" "/usr/local/share/ca-certificates/"
sudo update-ca-certificates
