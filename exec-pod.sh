#!/usr/bin/env bash
set -e

POD=$(kubectl -n tasky get po -o jsonpath={.items[0].metadata.name})

kubectl -n tasky exec -i -t $POD -- /bin/ash
