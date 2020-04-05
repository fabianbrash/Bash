#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

##disable selinux
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
