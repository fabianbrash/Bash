#!/bin/bash


##.USAGE:    ./umds.sh PORT PATH
##.EXAMPLE:  ./umds.sh 80 /usr/local/share


#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi


DEFAULTPORT=8080
DEFAULTPATH=/umds-store67

THEPORT=$1
THEPATH=$2

if [ -z $1 ]
   then
        THEPORT=$DEFAULTPORT
fi

if [ -z $2 ]
   then
        THEPATH=$DEFAULTPATH
fi


##Create our answer file note I need to get the questions again
echo "Creating UMDS answer file"

cat > /tmp/answer << __EOF__
/usr/local/vmware-umds
yes
no
$THEPATH

__EOF__


#Install umds
#/umds-staging/vmware-install.pl EULA_AGREED=yes
cat /tmp/answer | /umds-staging/vmware-install.pl EULA_AGREED=yes


###The certificate issue note this is to have been fixed in 6.5U2 
##REF:https://kb.vmware.com/s/article/53059?lang=en_US

#mv /usr/local/vmware-umds/lib/libcurl.so.4 /usr/local/vmware-umds/lib/libcurl.so.4.backup
#ln -s /usr/lib64/libcurl.so.4 /usr/local/vmware-umds/lib/libcurl.so.4

##Let's see what patches we are going to download and then download them

cd /usr/local/vmware-umds/bin
./vmware-umds -G
sleep 10

#Please note in python3 this has been renamed to http.server so the below command becomes
# python -m http.server 8080 or python -m http.server 8080 --bind 127.0.0.1
# also http.server 8080 --bind 127.0.0.1 --directory /umds-store point to a specific location to serve our website

