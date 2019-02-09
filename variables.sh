#!/bin/bash


#USAGE: ./test.sh PORT PATH
#EXAMPLE: ./test.sh 9000 /usr/share/local


DEFAULTPORT=8080
DEFAULTLOCATION=/umds67-store

THEPORT=$1
THEPATH=$2

if [ -z "$1" ]
   then
    THEPORT=$DEFAULTPORT
fi

if [ -z "$2" ]
   then
    THEPATH=$DEFAULTLOCATION
fi

echo $THEPORT
echo $THEPATH
