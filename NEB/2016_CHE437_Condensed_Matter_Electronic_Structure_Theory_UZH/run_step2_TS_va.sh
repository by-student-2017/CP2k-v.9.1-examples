#!/bin/bash

NoTS=`awk 'BEGIN{E0=-999999.99} /E =/ {i=i+1; if($6>E0){No=i; E0=$6}} END{printf "%d", No}' ethane_neb_aba_8r.xyz`

tail -n 10 "ethane_neb_aba-pos-Replica_nr_${NoTS}-1.xyz" >> ethane_neb_aba_TS.xyz

molden_adress="${HOME}/molden7.3/bin"

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i ethane_TS_va.inp | tee ethane_TS_va.out

echo "check Norm. Mode on Molden Control"

${molden_adress}/molden ethane_TS_va-VIBRATIONS-1.mol
