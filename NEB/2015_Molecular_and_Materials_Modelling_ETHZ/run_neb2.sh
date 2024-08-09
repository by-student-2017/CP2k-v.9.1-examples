#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i neb2.inp -o neb2.out

ndata=10

for ((i=1;i<=${ndata};i++)); do
  a=`echo $i | awk '{printf("%02d",$1)}'`
  tail -n 9 neb2-pos-Replica_nr_${a}-1.xyz >> movie.xyz
done

echo -n > neb2_profile
for ((i=1;i<=${ndata};i++)); do
  a=`echo $i | awk '{printf("%02d",$1)}'`
  grep ENERGY  neb2-BAND${a}.out | tail -n 1 | awk '{print '${a}',$9}' >> neb2_profile
done

echo "plot 'neb1_profile' w lp pt 7; set xlabel 'Step' ; set ylabel 'Energy / Hatree' ; pause mouse" |  gnuplot
