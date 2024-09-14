#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

echo "copy complex.prmtop to complex_LJ_mod.prmtop"
cp complex.prmtop complex_LJ_mod.prmtop

echo "---------- Moving on to QM/MM --------"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i monitor.inp | tee monitor.out


#parmed complex.prmtop
#changeLJSingleType :WAT@H1 0.3019 0.047
#changeLJSingleType :*@HO 0.3019 0.047
#outparm complex_LJ_mod.prmtop
#quit

#echo "---------- Metadynamics --------"
#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i metadynamics.inp | tee metadynamics.out

#graph -cp2k -file METADYN-1.restart -out fes.dat
