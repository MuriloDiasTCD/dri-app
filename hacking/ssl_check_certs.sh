#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SSLCONFIG=$SCRIPTPATH/../config/ssl
echo -e "\nchecking $(readlink -f $SSLCONFIG) ..."

echo -e "\nchecking private key"
openssl rsa -in $SSLCONFIG/localhost.key -check -noout

# echo -e "\nchecking cert"
# openssl x509 -in $SSLCONFIG/localhost.crt -text -noout

echo -e "\nmd5s should match"
openssl x509 -noout -modulus -in $SSLCONFIG/localhost.crt | openssl md5
openssl rsa -noout -modulus -in $SSLCONFIG/localhost.key | openssl md5
