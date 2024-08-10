#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i geo_init.inp -o geo_init.out

mv ch3cl-pos-1.xyz ch3cl-pos-1_init.xyz

tail -n 8 ch3cl-pos-1_init.xyz > init.xyz

#------------------------------------------------------------------------

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i geo_final.inp -o geo_final.out

mv ch3cl-pos-1.xyz ch3cl-pos-1_final.xyz

tail -n 8 ch3cl-pos-1_final.xyz > final.xyz