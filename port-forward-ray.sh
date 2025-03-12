#!/bin/bash


kubectl -n kuberay --kubeconfig=MY_KUBECONFIG port-forward service/ray-cluster-kuberay-head-svc 8265:8265 10001:10001 8080:8080 6379:6379 8000:8000
