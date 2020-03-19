#!/bin/bash

for instance in controller-0 controller-1 controller-2 worker-0 worker-1 worker-2; do

    IP_FORWARDING=$(ssh root@${instance} sysctl net.ipv4.ip_forward)
    
    echo $IP_FORWARDING
    
done
