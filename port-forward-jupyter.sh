#!/bin/bash



kubectl --kubeconfig=config.yaml -n jupyter-1 port-forward service/jupyter-1-notebook 8888:8888
