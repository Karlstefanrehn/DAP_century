#!/bin/bash

rm grass.bin

./DDcentEVI -s grass -n grass
./DDClist100 grass grass outvars.txt
