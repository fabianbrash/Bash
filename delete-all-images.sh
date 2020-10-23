#!/bin/bash

sudo docker rmi $(sudo docker images -a -q)

sleep 10


