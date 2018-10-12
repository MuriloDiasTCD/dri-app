#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SSLCONFIG="$SCRIPTPATH/../config/ssl"

openssl verify $SSLCONFIG/localhost.key $SSLCONFIG/localhost.crt
