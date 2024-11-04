#!/bin/bash


systemctl stop ufw
systemctl mask ufw


curl -sfL https://get.k3s.io | sh -