#!/bin/bash


#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

#Just in case we don't have it
yum install -y curl


curl -LO https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64
curl -LO https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_linux_amd64

mv cfssl_1.4.1_linux_amd64 cfssl
mv cfssljson_1.4.1_linux_amd64 cfssljson

chmod +x cfssl
chmod +x cfssljson

mv cfssl cfssljson /usr/local/bin

sleep 5

cfssl version

cfssljson -version
