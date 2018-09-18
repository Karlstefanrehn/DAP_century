#!/bin/bash

rm opp.bin

./DDcentEVI -s opp -n opp
./DDClist100 opp opp outvars.txt
