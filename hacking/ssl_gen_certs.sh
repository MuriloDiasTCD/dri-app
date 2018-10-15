#!/bin/bash
# https://rossta.net/blog/local-ssl-for-rails-5.html

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SSLCONFPAHTH="$SCRIPTPATH/../config/ssl"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -sha256 \
  -keyout "$SSLCONFPAHTH/key.pem" \
  -subj /CN=localhost \
  -out "$SSLCONFPAHTH/cert.pem"

# doesn't work on chrome anyway, still need to click proceed
# copy cert file to local share to trust it
echo -e "\nadding cert to trusted list..."
sudo cp "$SSLCONFPAHTH/cert.pem" "/usr/local/share/ca-certificates/"
sudo update-ca-certificates -vf
