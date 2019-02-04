#!/bin/bash


#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

yum upgrade -y

yum install perl psmisc vim epel-release python  -y

# Instead of Apache we can use the simple web server python provides

firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

#Store umds download store off / you can change this to wherever
mkdir /umds-store

##Create our answer file note I need to get the questions again
echo "Creating UMDS answer file"

cat > /tmp/answer << __EOF__
/usr/local/vmware-umds
yes
no
/umds-store

__EOF__

#Extract our perl script
cd /tmp
curl -OL https://s3.aws.amazon.com/umds.tgz
tar -zxvf umds.tgz

#Install umds
cat /tmp/answer | /tmp/umds.pl EULA_AGREED=yes

#Now we can start SimpleHttp 

cd /umds-store

#Please note in python3 this has been renamed to http.server so the below command becomes
# python -m http.server 8080 or python -m http.server 8080 --bind 127.0.0.1
# also http.server 8080 --bind 127.0.0.1 --directory /umds-store point to a specific location to serve our website
python -m SimpleHttpServer 8080

