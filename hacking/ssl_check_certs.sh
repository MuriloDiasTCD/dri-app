#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SSLCONFIG=$SCRIPTPATH/../config/ssl
echo -e "\nchecking $(readlink -f $SSLCONFIG) ..."
echo -e "checking private key"
openssl rsa -in $SSLCONFIG/key.pem -check -noout

echo -e "\nmd5s should match"
openssl x509 -noout -modulus -in $SSLCONFIG/cert.pem | openssl md5
openssl rsa -noout -modulus -in $SSLCONFIG/key.pem | openssl md5
