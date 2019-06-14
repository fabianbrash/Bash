#!/bin/bash

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

yum check-update
yum upgrade -y

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce

systemctl enable docker

systemctl start docker

##Add Firewall Rules for swarm note this assumes that the default zone is public
##Comment out if you won't be using swarm

firewall-cmd --add-port=2376/tcp --permanent --zone=public
firewall-cmd --add-port=2377/tcp --permanent --zone=public
firewall-cmd --add-port=7946/tcp --permanent --zone=public
firewall-cmd --add-port=7946/udp --permanent --zone=public
firewall-cmd --add-port=4789/udp --permanent --zone=public
firewall-cmd --reload

docker version
