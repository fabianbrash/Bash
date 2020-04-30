#!/bin/bash

#export KUBECONFIG=$HOME/.kube/config-kuadm-0:$HOME/.kube/config-kubespry-0

# Let's backup our config file first
FILE=~/.kube/config

if [ -f "$FILE" ]; then

    mv -f ~/.kube/config ~/.kube/configs/config.OLD
fi

# let's delete the current config file

if [ -f "$FILE" ]; then

    rm -f ~/.kube/config
fi

KUBECONFIG=~/.kube/configs/admin-tkg-mgmt.conf:~/.kube/configs/alexander-kubeconfig.yaml:~/.kube/configs/config-kubespry-0:~/.kube/configs/admin-kuadm-0 kubectl config view --flatten > ~/.kube/config

echo $KUBECONFIG
