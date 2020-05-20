#!/bin/bash


yum remove docker-ce -y && yum install -y docker-ce-3:19.03.8-3.el7.x86_64 && systemctl enable --now docker && docker version
