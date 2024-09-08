#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i S_M.inp | tee S_M.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i S_M.ene.inp | tee S_M.ene.out

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i S_M.MD.inp | tee S_M.MD.out
