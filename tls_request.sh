#!/bin/bash

mkdir -p /home/user/letsencrypt/logs
mkdir -p /home/user/letsencrypt/config
mkdir -p /home/user/letsencrypt/work

certbot certonly \
--dns-route53 \
--dns-route53-propagation-seconds 30 \
-d fqdn_of_your_server \
-m test@testemail.com \
--logs-dir /home/user/letsencrypt/logs \
--config-dir /home/user/letsencrypt/config \
--work-dir /home/user/letsencrypt/work \
--agree-tos \
--non-interactive
