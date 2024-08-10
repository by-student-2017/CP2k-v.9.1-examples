#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i geo.inp | tee cp2k_geo.out

cp FIN-pos-1.xyz s14_fin_eq.xyz
