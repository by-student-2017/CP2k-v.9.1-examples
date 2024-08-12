#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k hybrid.inp | tee hybrid.out

python plot_spectrum.py hybrid.spectrum Al 1s 1.0 1545 1570 1000
