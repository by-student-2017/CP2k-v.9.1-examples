#!/bin/bash

#Define topology files 
solv_parm="../003_leap/1HW9.wet.complex.parm7"
complex_parm="../003_leap/1HW9.complex.parm7"
receptor_parm="../003_leap/1HW9.gas.receptor.parm7"
lig_parm="../003_leap/1HW9.gas.ligand.parm7"
trajectory="10_prod.trj"

MMPBSA.py -O -i mmgbsa.in \
     -o 1S19_mmgbsa_results.dat \ 
     -eo 1S19_mmgbsa_perframe.dat \
     -sp  \
     -cp  \
     -rp  \
     -lp  \
      -y 
