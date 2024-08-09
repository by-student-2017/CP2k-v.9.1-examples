#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=1

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i Si7Ge-motion.inp | tee Si7Ge-motion.out
