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

yum upgrade -y && yum groupinstall "Development Tools" -y && yum install curl wget vim yum-plugin-versionlock epel-release ntp open-vm-tools pciutils tree yum-utils bind-utils net-tools -y
sleep 15
#yum install -y openssh-server
rm -f /etc/machine-id
systemd-machine-id-setup
systemctl enable --now vmtoolsd
systemctl enable --now ntpd
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
sleep 15
yum upgrade -y
