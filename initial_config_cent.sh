#!/bin/bash


#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

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

###Let's create some temp storage
mkdir /home/user/automated_temp
cd /home/user/automated_temp && curl -LO http://IP/sshkeys/keys.pub

####Let's setup ssh keys, we know there are 2 users on the system
#Replace user with the user you want to apply settings to
if [ ! -d /home/user/.ssh ]
 then
     mkdir /home/user/.ssh
fi

if [ ! -d /root/.ssh ]
 then
    mkdir /root/.ssh
fi

##Let's create our file and then inject with current keys
touch /home/user/.ssh/authorized_keys
cat /home/user/automated_temp/keys.pub >> /home/user/.ssh/authorized_keys

#Let's copy keys for root as well
touch /root/.ssh/authorized_keys
cat /home/user/automated_temp/keys.pub >> /root/.ssh/authorized_keys

##We have to do this because we will be running as root
chown -R user:user /home/user/.ssh

###set permission on authorized_keys file
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys

#Do for root as well
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys


###Cleanup time
rm -rf /home/user/automated_temp
