#!/bin/bash

firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="1.2.3.4/32" port protocol="tcp" port="3000" accept'
firewall-cmd --reload
