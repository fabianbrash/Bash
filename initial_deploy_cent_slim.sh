#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

##Initial config for a minimal CentOS install
##Configure our interface, this assumes ens192 is the name
#nmcli con add type ethernet con-name ens192-prod ifname ens192 ip4 $1/24 gw4 $2 ipv4.dns "8.8.8.8"
#nmcli con up ens192-prod
#sleep 5

echo "TASK[1] updating system and installing packages..."
yum upgrade -y && yum install wget vim epel-release ntp open-vm-tools pciutils tree yum-utils net-tools -y
sleep 15
echo "TASK[2] enabling services..."
systemctl enable --now vmtoolsd
systemctl start ntpd && systemctl enable ntpd
echo "TASK[3] enabling firewall rules..."
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
sleep 15
echo "TASK[4] checking for updates 1 more time..."
yum upgrade -y
