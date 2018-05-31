#!/bin/bash


#----------Let's install some basic tools for all our cent images--------------#

#--------Perl is required for VMware guest customization----------------------#

yum update -y && yum install yum-utils perl open-vm-tools -y

systemctl enable --now vmtoolsd
