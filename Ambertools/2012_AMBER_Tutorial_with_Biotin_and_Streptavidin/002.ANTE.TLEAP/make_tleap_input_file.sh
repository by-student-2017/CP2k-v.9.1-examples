#!/bin/bash

echo "#----- make tleap.lig.in -----#"
cat << EOF01 > tleap.lig.in
set default PBradii mbondi2                                      #set default PBradii
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/oldff/leaprc.ff99SB #load a force field
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.gaff
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.water.tip3p
loadamberparams 1DF8.lig.ante.frcmod
loadamberprep 1DF8.lig.ante.prep                                 #load an AMBER PREP file
lig = loadpdb 1DF8.lig.ante.pdb                                  #load the ligand pdb file
saveamberparm lig 1DF8.lig.gas.leap.prm7 1DF8.lig.gas.leap.rst7  #save the ligand gas phase AMBER topology and coordinate files
solvateBox lig TIP3PBOX 10.0                                     #solvate the receptor using TIP3P, solvent box radii 10 angstroms
saveamberparm lig 1DF8.lig.wat.leap.prm7 1DF8.lig.wat.leap.rst7  #save the ligand water phase AMBER topology and coordinate files
charge lig                                                       #charge the ligand
quit
EOF01

echo "#----- make tleap.rec.in -----#"
cat << EOF02 > tleap.rec.in
set default PBradii mbondi2
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/oldff/leaprc.ff99SB
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.gaff
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.water.tip3p
REC = loadpdb ../001.CHIMERA.MOL.PREP/1DF8.rec.noH.pdb
saveamberparm REC 1DF8.rec.gas.leap.prm7 1DF8.rec.gas.leap.rst7
solvateBox REC TIP3PBOX 10.0                                     
saveamberparm REC 1DF8.rec.wat.leap.prm7 1DF8.rec.wat.leap.rst7
charge REC
quit
EOF02

echo "#----- make tleap.com.in -----#"
cat << EOF03 > tleap.com.in
set default PBradii mbondi2
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/oldff/leaprc.ff99SB
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.gaff
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.water.tip3p
REC = loadpdb ../001.CHIMERA.MOL.PREP/1DF8.rec.noH.pdb
loadamberparams 1DF8.lig.ante.frcmod
loadamberprep 1DF8.lig.ante.prep
LIG = loadpdb 1DF8.lig.ante.pdb
COM = combine {REC LIG}
saveamberparm COM 1DF8.com.gas.leap.prm7 1DF8.com.gas.leap.rst7
solvateBox COM TIP3PBOX 10.0
saveamberparm COM 1DF8.com.wat.leap.prm7 1DF8.com.wat.leap.rst7
charge COM
quit
EOF03

