#!/bin/bash

mwchem_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${mwchem_adress}/nwchem h2o_resonant.nw | tee h2o_resonant.out

bash createlist

#vmd -e animate.cube.vmd