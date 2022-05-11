#!/bin/bash


kubectl-vsphere login --insecure-skip-tls-verify --server $TKGS_IP --tanzu-kubernetes-cluster-namespace fb-ns --tanzu-kubernetes-cluster-name fb-wcp-3 -u administrator@vsphere.local


kubectl-vsphere login --insecure-skip-tls-verify --server $TKGS_IP -u administrator@vsphere.local
