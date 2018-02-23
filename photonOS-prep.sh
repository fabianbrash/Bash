#!/bin/bash

groupadd -g 33 www-data
groupadd -g 999 docker
useradd www-data -u 33
usermod -G www-data -a www-data
systemctl start docker
systemctl enable docker
