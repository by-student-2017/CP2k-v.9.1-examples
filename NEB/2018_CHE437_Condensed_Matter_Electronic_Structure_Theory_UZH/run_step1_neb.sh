#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i ethane_neb_aba.inp | tee ethane_neb_aba.out

ndata=8

for ((i=1;i<=${ndata};i++)); do
  a=`echo $i | awk '{printf("%02d",$1)}'`
  tail -n 10 "ethane_neb_aba-pos-Replica_nr_${a}-1.xyz" >> ethane_neb_aba_8r.xyz
done

awk 'BEGIN{E0=-999999.99} /E =/ {i=i+1; printf "No.%s, %16.8f [Ha], Line:%d \n", i, $6, NR; if($6>E0){No=i; E0=$6; Line=NR}} END{printf "TS: No. %d, %16.8f [Ha], Line:%d \n", No, E0, Line}' ethane_neb_aba_8r.xyz
