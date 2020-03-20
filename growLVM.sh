#!/bin/bash

#Make sure we are running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

growpart /dev/sda 2
sleep 5
pvresize /dev/sda2
sleep 6
lvextend /dev/mapper/centos-root /dev/sda2
sleep 6
xfs_growfs /
sleep 5
df -h
