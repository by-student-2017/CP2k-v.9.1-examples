#!/bin/bash

NCPUs=8

echo "---------- AmberTools --------"

echo "please, change address following:"
echo "~/miniconda3/envs/AmberTools23"

for i in A B C; do antechamber -i Lig${i}.mol2 -o Ligand${i}.mol2 -fi mol2 -fo mol2 -c bcc -pf yes -nc -2 -at gaff2 -j 5 -rn CH${i}; done
for i in A B C; do parmchk2 -i Ligand${i}.mol2 -f mol2 -o Ligand${i}.frcmod -s 2; done

cat << EOF > script.in
#source leaprc.protein.ff14SB
#source leaprc.gaff2
#source leaprc.water.tip3p

source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.protein.ff14SB
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.gaff2
source ~/miniconda3/envs/AmberTools23/dat/leap/cmd/leaprc.water.tip3p
#loadamberparams ~/miniconda3/envs/AmberTools23/dat/leap/parm/frcmod.ionsjc_tip3p

ligA = loadmol2 LigandA.mol2
ligB = loadmol2 LigandB.mol2
ligC = loadmol2 LigandC.mol2

loadamberparams LigandA.frcmod
loadamberparams LigandB.frcmod
loadamberparams LigandC.frcmod


protein = loadPDB Protein.pdb
complex = combine {protein ligA ligB ligC}

solvateBox complex TIP3PBOX 14.0 iso
addIonsRand complex  Na+ 0
saveamberparm complex complex.prmtop complex.inpcrd
quit
EOF

tleap -f script.in


echo "---------- AmberTools (sander) --------"

cat << EOF01 > 01.min.mdin
Minimize
&cntrl
imin=1,           ! Minimize the initial structure
ntmin=2,          ! Use steepest descent Ryota Added
maxcyc=5000,      ! Maximum number of cycles for minimization
ntb=1,            ! Constant volume
ntp=0,            ! No pressure scaling
ntf=1,            ! Complete force evaluation
ntwx= 1000,       ! Write to trajectory file every ntwx steps
ntpr= 1000,       ! Print to mdout every ntpr steps
ntwr= 1000,       ! Write a restart file every ntwr steps
cut=  8.0,        ! Nonbonded cutoff in Angstroms
ntr=1,            ! Turn on restraints
restraintmask="!@H=", ! atoms to be restrained
restraint_wt=5.0, ! force constant for restraint
ntxo=1,           ! Write coordinate file in ASCII format
ioutfm=0,         ! Write trajectory file in ASCII format
/
EOF01

#mpirun -np ${NCPUs} sander -O -i 01.min.mdin -o 01.min.mdout -p complex.prmtop -c complex.inpcrd -ref complex.inpcrd -x 01.min.trj -inf 01.min.info -r 01.min.rst7

cat << EOF02 > 02.equil.mdin
MD Simulation
&cntrl
imin=0,           ! Perform MD
nstlim=50000      ! Number of MD steps
ntb=2,            ! Constant Pressure
ntc=1,            ! No SHAKE on bonds between hydrogens
dt=0.001,         ! Timestep (ps)
ntp=1,            ! Isotropic pressure scaling
barostat=1        ! Berendsen
taup=0.5          ! Pressure relaxtion time (ps)
ntf=1,            ! Complete force evaluation
ntt=3,            ! Langevin thermostat
gamma_ln=2.0      ! Collision Frequency for thermostat
ig=-1,            ! Random seed for thermostat
temp0=298.15      ! Simulation temperature (K)
ntwx= 1000,       ! Write to trajectory file every ntwx steps
ntpr= 1000,       ! Print to mdout every ntpr steps
ntwr= 1000,       ! Write a restart file every ntwr steps
cut=  8.0,        ! Nonbonded cutoff in Angstroms
ntr=1,            ! Turn on restraints
restraintmask=":!@H=", ! atoms to be restrained
restraint_wt=5.0, ! force constant for restraint
ntxo=1,           ! Write coordinate file in ASCII format
ioutfm=0,         ! Write trajectory file in ASCII format
iwrap=1,          ! iwrap is turned on
/
EOF02

#mpirun -np ${NCPUs} sander -O -i 02.equil.mdin -o 02.equil.mdout -p complex.prmtop -c 01.min.rst7 -ref 01.min.rst7 -x 02.equil.trj -inf 02.equil.info -r 02.equil.rst7
