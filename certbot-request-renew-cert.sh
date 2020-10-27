#!/bin/bash

certbot certonly -d myservice.domain.com --manual --preferred-challenges dns --agree-tos -m mail@mail.com
