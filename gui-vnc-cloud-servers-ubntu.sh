#!/bin/bash

#REF:https://www.suhendro.com/2019/04/ubuntu-cloud-desktop-adding-gui-to-your-cloud-server-instance/

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

apt install -y tightvncserver xfonts-75dpi xfonts-100dpi gsfonts-x11

apt install -y ubuntu-mate-core

#Startup vnc server
vncserver

##Kill vnc server
#vncserver -kill :1 (not :1 if that's the one you want to kill vnc can have multiple sessions i.e. :2, :3
