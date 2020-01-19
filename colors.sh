#!/bin/bash

##REF:https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'


echo -e "${GREEN}This text should be green"
echo -e ${NC}
