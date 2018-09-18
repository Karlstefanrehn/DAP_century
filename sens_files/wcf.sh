#!/bin/bash

rm wcf.bin

./DDcentEVI -s wcf -n wcf
./DDClist100 wcf wcf outvars.txt
