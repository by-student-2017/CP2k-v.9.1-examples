#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i geo.in | tee geo.out

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md.in | tee md.out
