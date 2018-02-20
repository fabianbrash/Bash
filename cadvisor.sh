#!/bin/bash

docker run -d -p 8090:8080 \
--volume=/var/run:/var/run:rw \
--volume=/sys:/sys:ro \
--volume=/var/lib/docker/:/var/lib/docker:ro \
--volume=/cgroup:/cgroup:ro \
--name=cadvisor \
--restart=always \ 
--privileged=true \
google/cadvisor:latest
