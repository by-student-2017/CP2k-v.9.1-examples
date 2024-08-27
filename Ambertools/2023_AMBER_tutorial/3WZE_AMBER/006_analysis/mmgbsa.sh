#!/bin/bash

solv_parm="../003.tleap/3wze.wet.complex.prmtop"
complex_parm="../003.tleap/3wze.complex.parm7"
receptor_parm="../003.tleap/3wze.gas.receptor.parm7"
lig_parm="../003.tleap/3wze.gas.ligand.parm7"

trajectory="../005.production/10_prod.trj"

MMPBSA.py -O -i mmgbsa.in \
     -o  3wze_mmgbsa_results.dat \
     -eo 3wze_mmgbsa_perframe.dat \
     -sp ${solv_parm} \
     -cp ${complex_parm} \
     -rp ${receptor_parm} \
     -lp ${lig_parm} \
      -y ${trajectory}
