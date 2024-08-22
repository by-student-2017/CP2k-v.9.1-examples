#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

#Note: https://www.ag.kagawa-u.ac.jp/charlesy/memo/md-simulation/protein-ligand-complex/ (Japanese)

# Test: AmberTools23 (conda), AM1-BCC2 charge method, general AMBER force field 2 (GAFF2)
antechamber -i MOL.pdb -fi pdb -o PRB.prep -fo prepi -c bcc -nc 0 -at gaff2
parmchk2 -i PRB.prep -f prepi -o PRB.frcmod -s gaff2
tleap -f leap.in

# Test: AmberTools23 (conda), Gastiger charge method, general AMBER force field (GAFF)
#antechamber -i MOL.pdb -fi pdb -o PRB.prep -fo prepi -c gas -nc 0 -at gaff
#parmchk2 -i PRB.prep -f prepi -o PRB.frcmod -s gaff
#tleap -f leapcomm

# Test: AmberTools23 (conda), AM1-BCC2 charge method, general AMBER force field (GAFF)
#antechamber -i MOL.pdb -fi pdb -o output.mol2 -fo mol2 -c bcc -nc 0 -at gaff
#parmchk2 -i output.mol2 -f mol2 -o output.frcmod
#tleap -f leap.gaff
