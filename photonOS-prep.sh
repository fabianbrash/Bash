#!/bin/bash

groupadd -g 33 www-data
groupadd -g 999 docker
useradd -u 33 www-data
usermod -G www-data www-data
