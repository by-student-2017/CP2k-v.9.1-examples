#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i neb_PM6.inp | tee cp2k_neb_PM6.out

ndata=14

for ((i=1;i<=${ndata};i++)); do
  a=`echo $i | awk '{printf("%02d",$1)}'`
  tail -n $((2+2936)) "NEB-pos-Replica_nr_${a}-1.xyz" >> neb_aba_14r.xyz
done

awk 'BEGIN{E0=-999999.99} /E =/ {i=i+1; printf "No.%s, %16.8f [Ha], Line:%d \n", i, $6, NR; if($6>E0){No=i; E0=$6; Line=NR}} END{printf "Emax: No. %d, %16.8f [Ha], Line:%d \n", No, E0, Line}' neb_aba_14r.xyz
