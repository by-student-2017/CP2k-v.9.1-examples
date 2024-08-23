#!/bin/bash

export OMP_NUM_THREADS=8

#sudo apt -y install dos2unix

echo "conda activate AmberTools23"
conda activate AmberTools23
which antechamber

#-----------------------------------------------------------------------------------------
echo "Download the protein coordinates"
wget https://files.rcsb.org/download/1NPO.pdb
#-----------------------------------------------------------------------------------------
echo "Structure preparation with tleap"

cat << EOF1 > oxy.scr
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/oldff/leaprc.ff03
oxy = loadPdb oxyt.pdb
bond oxy.1.SG oxy.6.SG
check oxy
saveAmberParm oxy oxy_vac.top oxy_vac.crd
solvateOct oxy TIP3PBOX 9.0
saveAmberParm oxy oxy.top oxy.crd
Quit
EOF1

tleap -s -f oxy.scr
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
#-----------------------------------------------------------------------------------------
# ANALYSIS
#-----------------------------------------------------------------------------------------