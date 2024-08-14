#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_1536.inp | tee md_1536.out

grep Shake  deca_ala_md_1536-1.LagrangeMultLog | awk '{c++ ; s=s+$4}END{print s/c}'

grep Rattle deca_ala_md_1536-1.LagrangeMultLog | awk '{c++ ; s=s+$4}END{print s/c}'
