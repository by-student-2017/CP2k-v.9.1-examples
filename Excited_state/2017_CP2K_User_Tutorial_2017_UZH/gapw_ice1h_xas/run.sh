#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k ice_xas_gapw.inp | tee ice_xas_gapw.out

bash ./../LIB_TOOLS/get_average_spectrum.sh

echo "plot 'spectrum.inp' using 2:6 with l,  'spectrum.out' using 1:5 with l; set xlabel 'Energy / eV' ; set ylabel 'Intensity / arb.units' ; pause mouse" |  gnuplot


FILE1="./../gapw_water_xas/spectrum.out"

FILE2="./../gapw_ice1h_xas/spectrum.out"

if [ -e "$FILE1" ] && [ -e "$FILE2" ]; then
  echo "plot ${FILE1} using 1:5 with l,  ${FILE2} using 1:5 with l; set xlabel 'Energy / eV' ; set ylabel 'Intensity / arb.units' ; pause mouse" |  gnuplot
else
  echo "One or both files do not exist."
fi
