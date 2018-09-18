#!/bin/bash

rm wf.bin

./DDcentEVI -s wf -n wf
./DDClist100 wf wf outvars.txt
