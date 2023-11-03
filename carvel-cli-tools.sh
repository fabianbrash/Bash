#!/bin/bash

curl -LO https://github.com/carvel-dev/ytt/releases/download/v0.46.0/ytt-linux-amd64
chmod +x ytt-linux-amd64
sudo mv ytt-linux-amd64 /usr/local/bin/ytt

curl -LO https://github.com/carvel-dev/imgpkg/releases/download/v0.39.0/imgpkg-linux-amd64
chmod +x imgpkg-linux-amd64
sudo mv imgpkg-linux-amd64 /usr/local/bin/imgpkg

curl -LO https://github.com/carvel-dev/kbld/releases/download/v0.38.0/kbld-linux-amd64
chmod +x kbld-linux-amd64
sudo mv kbld-linux-amd64 /usr/local/bin/kbld

curl -LO https://github.com/carvel-dev/kapp/releases/download/v0.59.0/kapp-linux-amd64
chmod +x kapp-linux-amd64
sudo mv kapp-linux-amd64 /usr/local/bin/kapp

curl -LO https://github.com/carvel-dev/vendir/releases/download/v0.35.0/vendir-linux-amd64
chmod +x vendir-linux-amd64
sudo mv vendir-linux-amd64 /usr/local/bin/vendir

curl -LO https://github.com/carvel-dev/kapp-controller/releases/download/v0.48.1/kctrl-linux-amd64
chmod +x kctrl-linux-amd64
sudo mv kctrl-linux-amd64 /usr/local/bin/kctrl

curl -LO https://github.com/vmware-tanzu/tanzu-cli/releases/download/v1.1.0/tanzu-cli-linux-amd64.tar.gz

tar -xzvf tanzu-cli-linux-amd64.tar.gz

sudo mv ./v1.1.0/tanzu-cli-linux_amd64 /usr/local/bin/tanzu