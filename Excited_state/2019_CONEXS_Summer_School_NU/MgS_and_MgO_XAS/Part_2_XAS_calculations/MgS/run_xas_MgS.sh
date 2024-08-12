#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k MgS_xas.inp | tee MgS_xas.out

#echo "plot 'spectrum.inp' using 2:6 with l,  'spectrum.out' using 1:5 with l; set xlabel 'Energy / eV' ; set ylabel 'Intensity / arb.units' ; pause mouse" |  gnuplot
#echo "plot 'spectrum.out' using 1:5 with l; set xlabel 'Energy / eV' ; set ylabel 'Intensity / arb.units' ; pause mouse" |  gnuplot

bash ./../../LIB_TOOLS/get_average_spectrum_at1.sh
cp spectrum.inp S_K-edge.inp
cp spectrum.out S_K-edge.out
echo "plot 'S_K-edge.out' using 1:5 with l; set xlabel 'Energy / eV' ; set ylabel 'Intensity / arb.units' ; pause mouse" |  gnuplot

bash ./../../LIB_TOOLS/get_average_spectrum_at2.sh
cp spectrum.inp Mg_K-edge.inp
cp spectrum.out Mg_K-edge.out
echo "plot 'Mg_K-edge.out' using 1:5 with l; set xlabel 'Energy / eV' ; set ylabel 'Intensity / arb.units' ; pause mouse" |  gnuplot
