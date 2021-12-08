#!/bin/bash

rm -r ./result
mkdir result
mkdir temp

pip3 uninstall PIL
pip3 install PIL
pip3 install image

python3 generate.py

rm -r ./temp
rm temp.json