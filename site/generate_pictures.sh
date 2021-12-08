#!/bin/bash

mkdir static
mkdir temp

python3 generate.py

rm -r ./temp
rm temp.json