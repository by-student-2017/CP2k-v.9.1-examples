#!/bin/bash

export OMP_NUM_THREADS=4

#sudo apt -y install dos2unix

echo "conda activate AmberTools23"
conda activate AmberTools23
which antechamber

#-----------------------------------------------------------------------------------------
cp ./Ref/sustiva.pdb ./

echo "#----- add all the hydrogen atoms to the pdb file -----#"
reduce sustiva.pdb > sustiva_h.pdb

echo '#----- change the name of the residue from "EFZ" to "SUS" -----#'
sed -e "s/EFZ/SUS/g" sustiva_h.pdb > sustiva_new.pdb

echo "#----- create the "mol2" file -----#"
antechamber -i sustiva_new.pdb -fi pdb -o sustiva.mol2 -fo mol2 -c bcc -s 2

echo "#----- test if all the parameters we require are available -----#"
parmchk2 -i sustiva.mol2 -f mol2 -o sustiva.frcmod

ls $HOME/miniconda3/envs/AmberTools23/dat/leap/cmd/
echo "#----- oldff -----#"
ls $HOME/miniconda3/envs/AmberTools23/dat/leap/cmd/oldff

cat << EOF1 > tleap.in
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/oldff/leaprc.ff99SB
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.gaff
SUS = loadmol2 sustiva.mol2 
check SUS 
loadamberparams sustiva.frcmod
saveoff SUS sus.lib 
saveamberparm SUS sustiva.prmtop sustiva.inpcrd
quit 
EOF1

echo "#----- Creating topology and coordinate files -----#"
tleap -f tleap.in

#-----------------------------------------------------------------------------------------
cp ./Ref/1FKO_trunc.pdb ./

echo '#----- change the name of the residue from "EFZ" to "SUS" -----#'
sed "s/EFZ/SUS/g" 1FKO_trunc.pdb > 1FKO_trunc_sus.pdb

cat << EOF2 > tleap2.in
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/oldff/leaprc.ff99SB
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.gaff
loadamberparams sustiva.frcmod 
loadoff sus.lib 
complex = loadpdb 1FKO_trunc_sus.pdb 
saveamberparm complex 1FKO_sus.prmtop 1FKO_sus.inpcrd
savepdb complex 1FKO_sus.pdb 

quit 
EOF2

echo "#----- Creating topology and coordinate files for Sustiva-RT complex -----#"
tleap -f tleap2.in

vmd -e vmd.tcl 1FKO_sus.pdb

cat << EOF3 > min.in
Initial minimisation of sustiva-RT complex
 &cntrl
  imin=1, maxcyc=200, ncyc=50,
  cut=16, ntb=0, igb=1,
 &end
EOF3

echo "#----- Minimize the Sustiva-RT complex -----#"
sander -O -i min.in -o 1FKO_sus_min.out -p 1FKO_sus.prmtop -c 1FKO_sus.inpcrd -r 1FKO_sus_min.crd

echo "#----- generate a pdb of the final minimized structures -----#"
cpptraj -p 1FKO_sus.prmtop -y 1FKO_sus_min.crd -x 1FKO_sus_min.pdb
ambpdb -p 1FKO_sus.prmtop -v < 1FKO_sus_min.crd > 1FKO_sus_min.pdb

cat << EOF4 > eq.in
Initial MD equilibration
 &cntrl
  imin=0, irest=0,
  nstlim=1000,dt=0.001, ntc=1,
  ntpr=20, ntwx=20,
  cut=16, ntb=0, igb=1,
  ntt=3, gamma_ln=1.0,
  tempi=0.0, temp0=300.0,
 &end
EOF4

echo "#----- Equilibrate the Sustiva-RT complex"
sander -O -i eq.in -o 1FKO_sus_eq.out -p 1FKO_sus.prmtop -c 1FKO_sus_min.crd -r 1FKO_sus_eq.rst -x 1FKO_sus_eq.mdcrd

#-----------------------------------------------------------------------------------------