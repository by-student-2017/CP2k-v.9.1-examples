#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i H2O-256.inp | tee H2O-256.out

#chmod +x get_t_sigma.sh
bash ./get_t_sigma.sh run-H2O-256-pos-1.xyz

gfortran ./../LIB_TOOLS/msd.f90 -o ./../LIB_TOOLS/msd.x  # compile msd.x executable
./../LIB_TOOLS/msd.x < msd.in # check input file 'msd.in' before you run!

echo "plot 'msd-256.dat' using 1:2 with l; set xlabel 'Time / fs' ; set ylabel 'Mean squared displacement / Angstrom^2' ; pause mouse" |  gnuplot
