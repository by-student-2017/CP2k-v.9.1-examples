#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

echo "---------- MD calculation --------"

echo "cp2k can be run using several processes, where N is the number of processes:"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i em.inp | tee em.out

echo "perform 5 ps of dynamics in the NVT ensemble"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i nvt.inp | tee nvt.out

echo "perform 50 ps of constant pressure NPT ensemble"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i npt.inp | tee npt.out
