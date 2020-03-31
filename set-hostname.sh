#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi


##Set a hostname for the system, this is argument 3
hostnamectl set-hostname $1 --static
systemctl restart systemd-hostnamed
