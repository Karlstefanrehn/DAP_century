#!/bin/bash

rm wcmf.bin

./DDcentEVI -s wcmf -n wcmf
./DDClist100 wcmf wcmf outvars.txt
