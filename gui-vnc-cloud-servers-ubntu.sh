#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

apt install -y tightvncserver xfonts-75dpi xfonts-100dpi gsfonts-x11

apt install -y ubuntu-mate-core
