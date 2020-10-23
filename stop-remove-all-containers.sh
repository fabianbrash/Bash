#!/bin/bash

sudo docker stop $(sudo docker ps -a -q)

sleep 10

sudo docker rm $(sudo docker ps -a -q)


