#!/bin/bash


MONTH_YEAR=$(date --iso-8601)

rm -f fabianbrash.tar.gz

sleep 2

tar -zcvf fabianbrash-$MONTH_YEAR.tar.gz fabianbrash_com
