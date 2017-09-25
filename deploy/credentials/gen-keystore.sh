#!/bin/bash

openssl req -new -x509 -newkey rsa:2048 -sha256 -keyout jetty.key -out jetty.crt 

openssl pkcs12 -inkey jetty.key -in jetty.crt -export -out idp-browser.p12
