#!/bin/bash

export OMP_NUM_THREADS=4

#sudo apt -y install dos2unix

echo "conda activate AmberTools23"
conda activate AmberTools23
which antechamber

#-----------------------------------------------------------------------------------------
echo "Download the protein coordinates"
wget https://files.rcsb.org/download/1NPO.pdb

echo "delete all header information and remove chains A, C, and D along with any water molecules and ions"
grep " B " 1NPO.pdb > oxyt.pdb

#-----------------------------------------------------------------------------------------
echo "Structure preparation with tleap"

#----------------------------------------------------
grep SG oxyt.pdb

# The disulfide bonds S-S (SG-SG), Note: Not mol2, but PDB.
cat << EOF0 > leap_pre.in
oxy = loadPdb oxyt.pdb
bond oxy.1.SG oxy.6.SG
check oxy
savepdb oxy oxyt_new.pdb
Quit
EOF0

tleap -s -f leap_pre.in

echo "#----- Add all the hydrogen atoms to the pdb file (reduce) -----#"
#-------
reduce oxyt_new.pdb > oxyt.H.pdb
# Note: obabel method is failed
#obabel -ipdb oxyt_new.pdb -opdb -O oxyt.H.pdb -h
#-------

antechamber -i oxyt.H.pdb -fi pdb -o oxyt.mol2 -fo mol2 -c gas -at gaff2
#----------------------------------------------------

parmchk2 -i oxyt.mol2 -f mol2 -o oxyt.frcmod -s gaff2

cat << EOF1 > leap_main.in
# Load force field parameters
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.protein.ff19SB
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.gaff2
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.water.tip3p

# Load extraparameters
loadamberparams oxyt.frcmod

# Load coordination file
oxy = loadmol2 oxyt.mol2
check oxy
saveAmberParm oxy oxy_vac.top oxy_vac.crd

# Solvate
solvateOct oxy TIP3PBOX 9.0
#solvateBox system TIP3PBOX 10 iso

# Neutralise
#addions2 system Cl- 0
#addions2 system Na+ 0

# Save AMBER input files
saveoff oxy oxy.lib 
saveAmberParm oxy oxy.top oxy.crd
Quit
EOF1

tleap -s -f leap_main.in
#-----------------------------------------------------------------------------------------
echo "Molecular Dynamics with Sander"
#-----------------------------------------------------------------------------------------
echo "Step 1. Energy Minimization of the System."

cat << EOF2 > min_vac.in 
oxytocin: initial minimization prior to MD
&cntrl
imin = 1,
maxcyc = 500,
ncyc = 250,
ntb = 0,
igb = 0,
cut = 12
/
EOF2

sander -O -i min_vac.in -o min_vac.out -p oxy_vac.top -c oxy_vac.crd -r oxy_vacmin.rst

echo "#----- Generate a pdb of the final minimized structures -----#"
cpptraj -p oxy_vac.top -y oxy_vac.crd -x oxy_vac_min.pdb
#vmd oxy_vac_min.pdb
ambpdb -p oxy_vac.top -c oxy_vac.crd > oxy_vac_min_ambpdb.pdb
#vmd oxy_vac_min_ambpdb.pdb
#-----------------------------------------------------------------------------------------
echo "Step 2: Molecular Dynamics"

cat << EOF3 > md_vac.in
oxytocin MD in-vacuo, 12 angstrom cut off, 250 ps
&cntrl
imin = 0, ntb = 0,
igb = 0, ntpr = 100, ntwx = 500,
ntt = 3, gamma_ln = 1.0,
tempi = 300.0, temp0 = 300.0,
nstlim = 125000, dt = 0.002,
cut = 12.0
/
EOF3

sander -O -i md_vac.in -o md_vac.out -p oxy_vac.top -c oxy_vacmin.rst -r oxy_vacmd.rst -x oxy_vacmd.mdcrd -ref oxy_vacmin.rst -inf mdvac.info

echo "#----- Generate a pdb of the Equilibrate MD trajectory -----#"
# convert trajectry file
cpptraj -p oxy_vac.top -y oxy_vacmd.mdcrd -x oxy_vac_eq.pdb
vmd oxy_vac_eq.pdb
#vmd -e vmd.tcl oxy_vac_eq.pdb

echo "#----- Generate a pdb of the final Equilibrate structures -----#"
ambpdb -p oxy_vac.top -c oxy_vac_eq.rst > oxy_vac_eq_ambpdb.pdb
#vmd oxy_vac_eq_ambpdb.pdb
#-----------------------------------------------------------------------------------------
# MOLECULAR DYNAMICS IN A WATER BOX
#-----------------------------------------------------------------------------------------
echo "Step 1: Restrained Minimization"

cat << EOF4 > min1.in
oxytocin: initial minimisation solvent + ions
&cntrl
imin = 1,
maxcyc = 1000,
ncyc = 500,
ntb = 1,
ntr = 1,
cut = 10
/
Hold the protein fixed
500.0
RES 1 9
END
END
EOF4

sander -O -i min1.in -o min1.out -p oxy.top -c oxy.crd -r oxy_min1.rst -ref oxy.crd

echo "#----- Generate a pdb of the final minimized structures -----#"
cpptraj -p oxy.top -y oxy.crd -x oxy_min1.pdb
#vmd oxy_min1.pdb
ambpdb -p oxy.top -c oxy.crd > oxy_min1_ambpdb.pdb
#vmd oxy_min1_ambpdb.pdb
#-----------------------------------------------------------------------------------------
echo "Step 2: Unrestrained Minimization"

cat << EOF5 > min2.in
oxytocin: initial minimisation whole system
&cntrl
imin = 1,
maxcyc = 2500,
ncyc = 1000,
ntb = 1,
ntr = 0,
cut = 10
/
EOF5

sander -O -i min2.in -o min2.out -p oxy.top -c oxy_min1.rst -r oxy_min2.rst

echo "#----- Generate a pdb of the final minimized structures -----#"
cpptraj -p oxy.top -y oxy.crd -x oxy_min2.pdb
#vmd oxy_min2.pdb
ambpdb -p oxy.top -c oxy.crd > oxy_min2_ambpdb.pdb
#vmd oxy_min2_ambpdb.pdb
#-----------------------------------------------------------------------------------------
echo "Step 3. Position-Restrained Dynamics"

cat << EOF6 > md1.in
oxytocin: 20ps MD with res on protein
&cntrl
imin = 0,
irest = 0,
ntx = 1,
ntb = 1,
cut = 10,
ntr = 1,
ntc = 2,
ntf = 2,
tempi = 0.0,
temp0 = 300.0,
ntt = 3,
gamma_ln = 1.0,
nstlim = 10000, dt = 0.002,
ntpr = 100, ntwx = 500, ntwr = 1000
/
Keep protein fixed with weak restraints
10.0
RES 1 9
END
END
EOF6

sander -O -i md1.in -o md1.out -p oxy.top -c oxy_min2.rst -r oxy_md1.rst -x oxy_md1.mdcrd -ref oxy_min2.rst -inf md1.info

echo "#----- Generate a pdb of the Equilibrate MD trajectory -----#"
# convert trajectry file
cpptraj -p oxy.top -y oxy_md1.mdcrd -x oxy_md1.pdb
vmd oxy_md1.pdb
#vmd -e vmd.tcl oxy_vac_eq.pdb

echo "#----- Generate a pdb of the final Equilibrate structures -----#"
ambpdb -p oxy.top -c oxy_min2.rst > oxy_md1_ambpdb.pdb
#vmd oxy_eq_ambpdb.pdb
#-----------------------------------------------------------------------------------------
echo "Step 4: The Production Run"

cat << EOF7 > md2.in
oxytocin: 250ps MD
&cntrl
imin = 0, irest = 1, ntx = 7,
ntb = 2, pres0 = 1.0, ntp = 1,
taup = 2.0,
cut = 10, ntr = 0,
ntc = 2, ntf = 2,
tempi = 300.0, temp0 = 300.0,
ntt = 3, gamma_ln = 1.0,
nstlim = 125000, dt = 0.002,
ntpr = 100, ntwx = 500, ntwr = 1000
/
EOF7

sander -O -i md2.in -o md2.out -p oxy.top -c oxy_md1.rst -r oxy_md2.rst -x oxy_md2.mdcrd -ref oxy_md1.rst -inf md2.info

echo "#----- Generate a pdb of the Equilibrate MD trajectory -----#"
# convert trajectry file
cpptraj -p oxy.top -y oxy_md2.mdcrd -x oxy_md2.pdb
vmd oxy_md1.pdb
#vmd -e vmd.tcl oxy_vac_eq.pdb

echo "#----- Generate a pdb of the final Equilibrate structures -----#"
ambpdb -p oxy.top -c oxy_md1.rst > oxy_md2_ambpdb.pdb
#vmd oxy_eq_ambpdb.pdb
#-----------------------------------------------------------------------------------------
# ANALYSIS
#-----------------------------------------------------------------------------------------