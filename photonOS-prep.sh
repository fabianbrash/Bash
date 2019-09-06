#!/bin/bash

groupadd -g 33 www-data
#groupadd -g 999 docker
useradd www-data -u 33
usermod -G www-data -a www-data

##Now add a user to the docker group so we don't have to use sudo or use the root account
useradd $1
sleep 3
usermod -aG docker $1
systemctl start docker
systemctl enable docker
sleep 10
###Let's set root to not expire

chage -l root ##Let's see what the expiry currently is
sleep 5
passwd -x -1 root  ###set to never expire

reboot

