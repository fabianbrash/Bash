#!/bin/bash

##Initial config for a minimal CentOS install
##Configure our interface, this assumes ens192 is the name
nmcli con add type ethernet con-name ens192-prod ifname ens192 ip4 $1/24 gw4 $2 ipv4.dns "8.8.8.8"
nmcli up ens192-prod
sleep 5
yum upgrade -y && yum group install "Development Tools" -y && yum install wget ntp vim firewalld epel-release open-vm-tools pciutils tree yum-utils -y
sleep 15
yum install -y openssh-server
systemctl start vmtoolsd && systemctl enable vmtoolsd
systemctl start ntpd && systemctl enable ntpd
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
sleep 30
yum upgrade -y

#####Docker installation for CENTOS 7.x#####
###Uncommnet if you would like docker-ce installed
#yum install -y yum-utils \
#device-mapper-persistent-data \
#lvm2

#yum-config-manager -y \
#--add-repo \
#https://download.docker.com/linux/centos/docker-ce.repo

#yum install docker-ce -y
#systemctl start docker && systemctl enable docker

#####Dccker centos install REF: https://docs.docker.com/install/linux/docker-ce/centos/#set-up-the-repository
