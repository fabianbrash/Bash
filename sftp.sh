#!/bin/bash


#-----------------------------------
#Let's add our sftp group
#-----------------------------------

groupadd $1

#-----------------------------------
#Let's add our user, note user
#will not have a shell
#-----------------------------------


useradd $2 -g $1 -s /bin/false


#-----------------------------------
#Set password for our user
#-----------------------------------

passwd $2

#-----------------------------------
#If you don't wish to set selinux
#to permissive
#-----------------------------------

setsebool -P ssh_chroot_rw_homedirs on
getsebool ssh_chroot_rw_homedirs


#----------------------------------
#TODO use text manipulation tools
#on Linux to edit /etc/ssh/ssh_config
#i.e. sed ...
#------------------------------------

#------------------------------------
#Things to change
#Subsystem       sftp   internal-sftp
#Match group sftpuser
#        ChrootDirectory %h
#        ForceCommand internal-sftp
#        X11Forwarding no
#        AllowTcpForwarding no
#------------------------------------

#-----------------------------------
#Make a directory for the user
#-----------------------------------

mkdir -p /home/$2/datadir
#mkdir -p /home/$2/$3

#-----------------------------------
#root must own the user's home dir
#-----------------------------------

chown root /home/$2
#chown root /home/$2

chmod 755 /home/$2
#chmod 755 /home/$2

#-----------------------------------
#Grant user access to there 'new' 
#home
#-----------------------------------

chown $2 /home/$2/datadir
#chown $2 /home/$2/$3

chmod 755 /home/$2/datadir
#chmod 755 /home/$2/$3

