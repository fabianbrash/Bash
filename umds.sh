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
mkdir /umds-store67

##Create our answer file note I need to get the questions again
echo "Creating UMDS answer file"

cat > /tmp/answer << __EOF__
/usr/local/vmware-umds
yes
no
/umds-store67

__EOF__

#Extract our perl script
cd /tmp
curl -OL https://s3.amazonaws.com/umds-6.7/VMware-UMDS-6.7.0-10164201.tar.gz
tar -zxvf VMware-UMDS-6.7.0-10164201.tar.gz

#Install umds
cat /tmp/answer | /tmp/vmware-umds-distrib/vmware-install.pl EULA_AGREED=yes

##Let's see what patches we are going to download and then download them

cd /usr/local/vmware-umds/bin
./vmware-umds -G
./vmware-umds -D

###The certificate issue note this is to have been fixed in 6.5U2 
##REF:https://kb.vmware.com/s/article/53059?lang=en_US

mv /usr/local/vmware-umds/lib/libcurl.so.4 /usr/local/vmware-umds/lib/libcurl.so.4.backup
ln -s /usr/lib64/libcurl.so.4 /usr/local/vmware-umds/lib/libcurl.so.4

#Now we can start SimpleHttp 

cd /umds-store67

#Please note in python3 this has been renamed to http.server so the below command becomes
# python -m http.server 8080 or python -m http.server 8080 --bind 127.0.0.1
# also http.server 8080 --bind 127.0.0.1 --directory /umds-store point to a specific location to serve our website
python -m SimpleHTTPServer 8080

