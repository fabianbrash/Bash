#!/bin/bash


DOMAIN="*.mydomain.net"
LOGSDIR="./logs"
CONFIGDIR="./config"
WORKDIR="./work"
EMAIL="me@me.com"

sudo certbot certonly -d myservice.domain.com --manual --preferred-challenges dns --agree-tos -m mail@mail.com


sudo certbot certonly -d ${DOMAIN} --manual --preferred-challenges dns --agree-tos -m me@me.com



# By specifying directories in the users home folder, we don't need root access

certbot certonly -d ${DOMAIN} --manual --preferred-challenges dns --agree-tos -m ${EMAIL} \
--logs-dir ${LOGSDIR} \
--config-dir ${CONFIGDIR} \
--work-dir ${WORKDIR}
