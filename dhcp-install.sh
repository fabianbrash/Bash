#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

yum upgrade -y
yum install -y dhcp-4.2.5

cp /usr/share/doc/dhcp-4.2.5/dhcpd.conf.example /etc/dhcp/dhcpd.conf


echo "Please head on over to /etc/sysconfig/dhcpd and edit the HDCPDARGS variable to the name of your interface ex eth0"


##If you are running firewalld uncomment the below lines

##allow firewall for dhcp ####
#firewall-cmd --permanent --zone=public --add-service=dhcp 
#firewall-cmd --reload

systemctl restart dhcpd
