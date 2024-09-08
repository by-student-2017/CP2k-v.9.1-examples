#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

#----------------------------------------------------------------------

echo "1. Task: Computing vibrational spectra for methanol and benzene"

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i optmet.inp | tee optmet.out
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i vibmet.inp | tee vibmet.out

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i optc6h6.inp | tee optc6h6.out
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i vibc6h6.inp | tee vibc6h6.out

#----------------------------------------------------------------------

gfortran dipole_correlation.f90 -o dipole_gf.x

#----------------------------------------------------------------------

echo "2. Task: Computing vibrational spectra using DFTB molecular dynamics"

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mdmet.inp | tee mdmet.out
cp dipole_met.in dipole.in
./dipole_gf.x < dipole.in
echo 'plot "dip_dip_correlation.time" u 1:2 w l' | gnuplot -p -

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mdc6h6.inp | tee mdc6h6.out
cp dipole_c6h6.in dipole.in
./dipole_gf.x < dipole.in
echo 'plot "dip_dip_correlation.time" u 1:2 w l' | gnuplot -p -

# https://www.cfa.harvard.edu/hitran/vibrational.html
#----------------------------------------------------------------------