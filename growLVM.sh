#!/bin/bash

growpart /dev/sda 2
sleep 5
pvresize /dev/sda2
sleep 6
lvextend /dev/mapper/centos-root /dev/sda2
sleep 6
xfs_growfs /
sleep 5
df -h
