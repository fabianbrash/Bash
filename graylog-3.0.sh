#/bin/bash

##Not sure if this is needed for 3.x but set it anyway, this is a fix for elasticsearch
sysctl -w vm.max_map_count=262144

sysctl -a | grep -i vm.max_map_count

docker run --name mongo -d mongo:4.0.10

docker run --name elasticsearch \
    -e "http.host=0.0.0.0" \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
    -d docker.elastic.co/elasticsearch/elasticsearch-oss:6.6.1

sleep 30

docker run --name graylog --link mongo --link elasticsearch \
    -p 9000:9000 -p 12201:12201 -p 1514:1514 -p 514:514 -p 514:514/udp \
    -e GRAYLOG_HTTP_EXTERNAL_URI="http://192.168.50.103:9000/" \
    -d graylog/graylog:3.0
