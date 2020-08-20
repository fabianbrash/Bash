#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

yum upgrade -y
yum install -y dhcp-4.2.5

#cp /usr/share/doc/dhcp-4.2.5/dhcpd.conf.example /etc/dhcp/dhcpd.conf

## just in case
yum install -y curl

curl -LO https://containerblobs.blob.core.windows.net/containerdata/dhcpd.conf

cp dhcpd.conf /etc/dhcp/

##If you are running firewalld uncomment the below lines

##allow firewall for dhcp ####
#firewall-cmd --permanent --zone=public --add-service=dhcp 
#firewall-cmd --reload

cat /var/log/messages

#this should generate an error until you configure correctly /etc/dhcp/dhcpd.conf
systemctl restart dhcpd
