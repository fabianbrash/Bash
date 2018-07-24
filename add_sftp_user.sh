#!/bin/bash


#-------------------------------------------
#Script accepts 2 args
#The group arg[0], the user arg[1]
#@Usage:
#sudo ./add_sftp_user.sh group new_user
#------------------------------------------

#------------------------------------------
#Add new sftp user, set there
#Password and add them
#To the appropriate group
#-----------------------------------------


#-----------------------------------------
#Let's add our user, note user
#will not have a shell
#----------------------------------------


useradd $2 -g $1 -s /bin/false


#---------------------------------------
#Set password for our user
#---------------------------------------

passwd $2


#--------------------------------------
#Make a directory for the user
#--------------------------------------

mkdir -p /home/$2/datadir
#mkdir -p /home/$2/$3

#-------------------------------------
#root must own the user's home dir
#-------------------------------------

chown root /home/$2
#chown root /home/$2

chmod 755 /home/$2
#chmod 755 /home/$2

#------------------------------------
#Grant user access to there 'new' 
#home
#------------------------------------

chown $2 /home/$2/datadir
#chown $2 /home/$2/$3

chmod 755 /home/$2/datadir
#chmod 755 /home/$2/$3