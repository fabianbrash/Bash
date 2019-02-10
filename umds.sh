#!/bin/bash


##USAGE:    ./umds.sh PORT PATH
##EXAMPLE:  ./umds.sh 80 /usr/local/share


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


yum upgrade -y

yum install perl psmisc vim epel-release python  -y

# Let's open up our port

firewall-cmd --add-port=$THEPORT/tcp --permanent
firewall-cmd --reload

#Store umds download store off / you can change this to wherever
mkdir $THEPATH

##Create our answer file note I need to get the questions again
echo "Creating UMDS answer file"

cat > /tmp/answer << __EOF__
/usr/local/vmware-umds
yes
no
$THEPATH

__EOF__

#Extract our perl script
cd /tmp
curl -OL https://s3.amazonaws.com/umds-6.7/VMware-UMDS-6.7.0-10164201.tar.gz
tar -zxvf VMware-UMDS-6.7.0-10164201.tar.gz

#Install umds
cat /tmp/answer | /tmp/vmware-umds-distrib/vmware-install.pl EULA_AGREED=yes

###The certificate issue note this is to have been fixed in 6.5U2 
##REF:https://kb.vmware.com/s/article/53059?lang=en_US

mv /usr/local/vmware-umds/lib/libcurl.so.4 /usr/local/vmware-umds/lib/libcurl.so.4.backup
ln -s /usr/lib64/libcurl.so.4 /usr/local/vmware-umds/lib/libcurl.so.4

##Let's see what patches we are going to download and then download them

cd /usr/local/vmware-umds/bin
./vmware-umds -G
sleep 15
echo "Now Go get some coffee..."
./vmware-umds -D


#Now we can start SimpleHTTPServer 

cd $THEPATH

#Please note in python3 this has been renamed to http.server so the below command becomes
# python -m http.server 8080 or python -m http.server 8080 --bind 127.0.0.1
# also http.server 8080 --bind 127.0.0.1 --directory /umds-store point to a specific location to serve our website
python -m SimpleHTTPServer $THEPORT

