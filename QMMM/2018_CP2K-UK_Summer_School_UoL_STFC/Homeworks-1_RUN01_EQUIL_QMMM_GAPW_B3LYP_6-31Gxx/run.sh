#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mol_solv_gapw_b3lyp.inp | tee mol_solv_gapw_b3lyp.out