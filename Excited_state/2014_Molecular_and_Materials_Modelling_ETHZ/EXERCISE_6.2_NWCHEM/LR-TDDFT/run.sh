#!/bin/bash

mwchem_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${mwchem_adress}/nwchem tddft_h2o_uhf.nw | tee tddft_h2o_uhf.out

python ./nwchem_tddft_spectrum.py -o tddft_h2o_uhf.out

#vmd -e homo.vmd
#vmd -e lumo.vmd