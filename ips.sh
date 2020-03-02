#!/bin/bash

for instance in worker-0 worker-1 worker-2; do 

        INTERNAL_IP=$(ssh root@${instance} hostname -I) 

        echo $INTERNAL_IP 


done
