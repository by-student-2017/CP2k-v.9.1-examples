#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i geo.in | tee geo.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md.in | tee md.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_FCC111.in | tee md_dftb_FCC111.out

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_BCC110.in | tee md_dftb_BCC110.out
