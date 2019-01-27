#/bin/bash



docker run --name elasticsearch \
    -e "http.host=0.0.0.0" -e "xpack.security.enabled=false" \
    -d docker.elastic.co/elasticsearch/elasticsearch:6.5.4

sleep 30

docker run --link mongo --link elasticsearch \
    -p 9000:9000 -p 12201:12201 -p 514:514 \
    -p 514:514/udp \
    --name graylog \
    -e GRAYLOG_WEB_ENDPOINT_URI="http://192.168.50.203:9000/api" \
    -d graylog/graylog:2.5
