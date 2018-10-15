#!/bin/bash
# https://rossta.net/blog/local-ssl-for-rails-5.html

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SSLCONFPAHTH="$SCRIPTPATH/../config/ssl"
name=localhost

# echo -e "\ngenerating private key..."
# openssl genrsa -out $SSLCONFPAHTH/$name.key 4096
# echo -e "\ngenerating cert sign request..."
# openssl req -new -key $SSLCONFPAHTH/$name.key -out $SSLCONFPAHTH/$name.csr \
#   -subj "/CN=$name/C=IE/ST=DUBLIN"
# echo -e "\ngenerating cert..."
# openssl x509 -req -days 365 -in $SSLCONFPAHTH/$name.csr \
#   -signkey $SSLCONFPAHTH/$name.key -out $SSLCONFPAHTH/$name.crt

# openssl req \
#   -newkey rsa:4096 \
#   -x509 \
#   -nodes \
#   -keyout "$SCRIPTPATH/$name.key" \
#   -new \
#   -out "$SCRIPTPATH/$name.crt" \
#   -subj /CN=localhost \
#   -reqexts SAN \
#   -sha256 \
#   -days 3650 \
#   -extensions SAN \
#   -config <(cat /usr/lib/ssl/openssl.cnf \
#       <(printf '[SAN]\nsubjectAltName=DNS:localhost'))

# openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout $name.key -out $name.crt -subj "/CN=localhost" -days 3650

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -sha256 \
  -keyout "$SSLCONFPAHTH/$name.key" \
  -subj /CN=localhost \
  -out "$SSLCONFPAHTH/$name.crt"

# doesn't work on chrome anyway, still need to click proceed
# copy cert file to local share to trust it
echo -e "\nadding cert to trusted list..."
sudo cp "$SSLCONFPAHTH/$name.crt" "/usr/local/share/ca-certificates/"
sudo update-ca-certificates -vf
