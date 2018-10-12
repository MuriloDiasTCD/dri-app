#!/bin/bash
# https://rossta.net/blog/local-ssl-for-rails-5.html

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
name=localhost

openssl req \
  -newkey rsa:2048 \
  -x509 \
  -nodes \
  -keyout $SCRIPTPATH/../config/ssl/$name.key \
  -new \
  -out $SCRIPTPATH/../config/ssl/$name.crt \
  -subj /CN=localhost \
  -reqexts SAN \
  -sha256 \
  -days 3650 \
  -extensions SAN \
  -config <(cat /usr/lib/ssl/openssl.cnf \
      <(printf '[SAN]\nsubjectAltName=DNS:localhost'))

# copy cert file to local share to trust it
sudo cp "$SCRIPTPATH/../config/ssl/$name.crt" "/usr/local/share/ca-certificates/"
sudo update-ca-certificates -vf
