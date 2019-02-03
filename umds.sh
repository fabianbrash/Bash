#!/bin/bash


yum upgrade -y

yum install perl psmisc vim epel-release python  -y

# Instead of Apache we can use the simple web server python provides

firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

#Store umds download store off / you can change this to wherever
mkdir /umds-store

#Now we can start SimpleHttp 

cd /umds-store

#Please note in python3 this has been renamed to http.server so the below command becomes
# python -m http.server 8080 or python -m http.server 8080 --bind 127.0.0.1
# also http.server 8080 --bind 127.0.0.1 --directory /umds-store point to a specific location to serve our website
python -m SimpleHttpServer 8080


##TODO add logic to install umds from .pl script
