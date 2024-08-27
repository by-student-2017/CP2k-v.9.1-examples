#!/bin/bash

#Define topology files                                                                                                                     
solv_prmtop="./../001.tleap_build/2nnq.wet.complex.prmtop"
complex_prmtop="./../001.tleap_build/2nnq.gas.complex.prmtop"
receptor_prmtop="./../001.tleap_build/2nnq.gas.receptor.prmtop"
ligand_prmtop="./../001.tleap_build/2nnq.gas.ligand.prmtop"
trajectory="./../003.production/001.restrained/10.prod.trj"

MMPBSA.py -O -i mmgbsa.in \
           -o  2nnq.mmgbsa.results.dat \
           -eo 2nnq.mmgbsa.per-frame.dat \
           -sp ${solv_prmtop} \
           -cp ${complex_prmtop} \
           -rp ${receptor_prmtop} \
           -lp ${ligand_prmtop} \
            -y ${trajectory}
            
