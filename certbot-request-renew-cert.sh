#!/bin/bash

sudo certbot certonly -d myservice.domain.com --manual --preferred-challenges dns --agree-tos -m mail@mail.com


sudo certbot certonly -d "*.mydomain.net" --manual --preferred-challenges dns --agree-tos -m me@me.com



# By specifying directories in the users home folder, we don't need root access

certbot certonly -d "*.mydomain.net" --manual --preferred-challenges dns --agree-tos -m me@me.com \
--logs-dir /home/user/letsencrypt/logs \
--config-dir /home/user/letsencrypt/config \
--work-dir /home/user/letsencrypt/work \
