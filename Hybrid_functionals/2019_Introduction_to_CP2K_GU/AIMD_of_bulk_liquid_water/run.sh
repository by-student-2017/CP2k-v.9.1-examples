#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water.inp | tee water.out

#cat WATER-1.ener
#echo 'plot "./WATER-1.ener" u 2:5 w lp, "./WATER-1.ener" u 2:6 w lp' | gnuplot -p -
#vmd WATER-pos-1.xyz

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water_cheating.inp | tee water_cheating.out

cat WATER-1.ener
echo 'plot "./WATER-1.ener" u 2:5 w lp, "./WATER-1.ener" u 2:6 w lp' | gnuplot -p -
vmd WATER-pos-1.xyz