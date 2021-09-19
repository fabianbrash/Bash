#!/bin/bash

docker run -d \
  -p 9000:9000 \
  -p 9001:9001 \
  -v minio_data:/data \
  minio/minio:RELEASE.2021-09-18T18-09-59Z server /data --console-address ":9001"