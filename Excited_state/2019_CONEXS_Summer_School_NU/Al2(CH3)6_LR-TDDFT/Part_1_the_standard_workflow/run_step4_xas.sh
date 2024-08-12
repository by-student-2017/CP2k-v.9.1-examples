#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k part1_xas.inp | tee part1_xas.out

python plot_spectrum.py part1.spectrum Al 1s 1.0 1500 1525 1000
