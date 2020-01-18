#/bin/bash

docker run -d -p 53:53/udp --restart always --name coredns -v /static_content/coredns_config/:/root/ coredns/coredns -conf /root/Corefile
