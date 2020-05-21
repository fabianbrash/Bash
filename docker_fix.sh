#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

yum install -y yum-plugin-versionlock
yum remove docker-ce -y && yum install -y docker-ce-3:19.03.8-3.el7.x86_64 && systemctl enable --now docker && docker version

yum versionlock docker-ce*

