#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i H2O-256.inp | tee H2O-256.out

gfortran ./../LIB_TOOLS/msd.f90 -o ./../LIB_TOOLS/msd.x  # compile msd.x executable

./../LIB_TOOLS/msd.x < msd.in # check input file 'msd.in' before you run!
