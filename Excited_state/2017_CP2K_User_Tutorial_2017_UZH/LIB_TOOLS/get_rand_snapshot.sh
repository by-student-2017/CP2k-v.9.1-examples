#!/bin/bash


rand_snap=`shuf -i 100-999 -n 1`
nats=`head WATER_AIMD-pos-1.xyz -n 1`
grep -A ${nats} -w "${rand_snap},"  WATER_AIMD-pos-1.xyz > coords.dat
echo ${nats} > nats.dat
cat nats.dat  coords.dat > water.xyz
rm nats.dat

