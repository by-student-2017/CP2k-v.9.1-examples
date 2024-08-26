#!/bin/bash

#Define topology files 
solv_prmtop="../../001.tleap_build/2P16.wet.complex.prmtop"
complex_prmtop="../../001.tleap_build/2P16.gas.complex.prmtop"
receptor_prmtop="../../001.tleap_build/2P16.gas.receptor.prmtop"
ligand_prmtop="../../001.tleap_build/2P16.gas.ligand.prmtop"
trajectory="../../003.production/001.restrained/10.prod.trj"

#create mmgbsa input file
cat >mmgbsa.in<<EOF
mmgbsa 2P16 analysis
&general
  interval=1, netcdf=1,
  keep_files=0,

/
&gb
  igb=8,
  saltcon=0.0, surften=0.0072,
  surfoff=0.0, molsurf=0,
/
&nmode
  drms=0.001, maxcyc=10000,
  nminterval=250, nmendframe=2000,
  nmode_igb=1, 
/
EOF

MMPBSA.py -O -i mmgbsa.in \
           -o  2P16.mmgbsa.results.dat \
           -eo 2P16.mmgbsa.per-frame.dat \
           -sp ${solv_prmtop} \
           -cp ${complex_prmtop} \
           -rp ${receptor_prmtop} \
           -lp ${ligand_prmtop} \
            -y ${trajectory}
