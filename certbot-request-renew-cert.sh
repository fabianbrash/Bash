#!/bin/bash

sudo certbot certonly -d myservice.domain.com --manual --preferred-challenges dns --agree-tos -m mail@mail.com


sudo certbot certonly -d "*.mydomain.net" --manual --preferred-challenges dns --agree-tos -m me@me.com
