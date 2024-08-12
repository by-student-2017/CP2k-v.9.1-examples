#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k hybrid.inp | tee hybrid.out

python plot_spectrum.py hybrid.spectrum Al 2s 1.0 107 185 1000

python plot_spectrum.py hybrid.spectrum Al 2p 1.0  68 147 1000
