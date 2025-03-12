#!/bin/bash


kubectl -n ai-apps-ns --kubeconfig=MY_KUBECONFIG port-forward svc/proxy-public 9000:80
