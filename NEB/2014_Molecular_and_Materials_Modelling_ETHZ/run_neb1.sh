#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i neb1.inp -o neb1.out

ndata=10

for ((i=1;i<=${ndata};i++)); do
  a=`echo $i | awk '{printf("%02d",$1)}'`
  tail -n 9 neb1-pos-Replica_nr_${a}-1.xyz >> movie.xyz
done

echo -n > neb1_profile
for ((i=1;i<=${ndata};i++)); do
  a=`echo $i | awk '{printf("%02d",$1)}'`
  grep ENERGY  neb1-BAND${a}.out | tail -n 1 | awk '{print '${a}',$9}' >> neb1_profile
done

echo "plot 'neb1_profile' w lp pt 7; set xlabel 'Step' ; set ylabel 'Energy / Hartree' ; pause mouse" |  gnuplot
