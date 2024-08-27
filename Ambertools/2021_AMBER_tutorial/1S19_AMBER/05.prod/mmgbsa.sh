#!/bin/bash

solv_parm="../03.leap/1S19_wetcomplex.parm7"
complex_parm="../03.leap/1S19_gascomplex.parm7"
receptor_parm="../03.leap/1S19_gasrec.parm7"
lig_parm="../03.leap/1S19_gaslig.parm7"
trajectory="../05.prod/10_prod.trj"

MMGBSA.py -O -i mmgbsa.in \
    -o 1S19_mmgbsa_results.dat \
    -eo 1S19_mmgbsa_perframe.dat \
    -sp ${solv_parm} \
    -cp ${complex_parm} \
    -rp ${receptor_parm} \
    -lp ${lig_parm} \
    -y  ${trajectory}
