#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k MgS_dscf.inp | tee MgS_dscf.out

grep -n "excited atom" *.out

echo "in the output file. The energy is given in Hartree, and to convert it to electron volts multiply the value by 27.211. This is the energy of the first transition, and you can use this value to rigidly shift your absorption spectrum."

echo "1st: at1 = X = S"
echo "2nd: at2 = Mg"