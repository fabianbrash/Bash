#!/bin/bash

#Create a new connection for production and take 2 arguments(IP and Gateway)
nmcli con add type ethernet con-name ens192-prod ifname ens192 ip4 $1/24 gw4 $2 ipv4.dns "8.8.8.8"
nmcli con up ens192-prod
sleep 5

##Set a hostname for the system, this is argument 3
hostnamectl set-hostname $3 --static
systemctl restart systemd-hostnamed

##Let's generate a new random machine ID this is applicable to centOS/RHEL 7.1 and above
rm -f /etc/machine-id
systemd-machine-id-setup


##TODO
####Let's setup ssh keys, we know there are 2 users on the system
if [ ! -d /home/user/.ssh ]
 then
     mkdir /home/user/.ssh
fi

touch /home/user/.ssh/autherized_keys

##We have to do this because we will be running as root
chown -R user:user /home/user/.ssh

cd /home/saprime && curl -LO http://serverIp/key.pub

cat /home/saprime/key.pub >> /home/saprime/.ssh/authorized_keys

###TODO set permission on authorized_keys file
