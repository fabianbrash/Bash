#!/bin/bash

# Before cleaning up make sure open-vm-tools and bzip is installed
apt update && \
apt -y upgrade && \
apt install -y open-vm-tools bzip2 \
apt -y autoremove && \
apt clean

# Delete any user(s) you don’t want in the final template
userdel -r ubuntu

# Clear the hostname
truncate -s0 /etc/hostname
hostnamectl set-hostname localhost

# Remove netplan file(s) if it exists
rm /etc/netplan/50-cloud-init.yaml

# Clear the machine-id

truncate -s0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# 
cloud-init clean

# Disable the Password for root

passwd -dl root

# Clear Shell History

truncate -s0 ~/.bash_history
history -c

# Shutdown the VM

shutdown -h now
