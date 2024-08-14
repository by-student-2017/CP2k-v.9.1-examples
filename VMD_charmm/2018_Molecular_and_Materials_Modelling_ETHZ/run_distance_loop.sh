#!/bin/bash

lammps_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

# from 12.3 to 12.5, 0.1 step
for i in $(seq 12.3 0.1 12.5)
do
   sed "s/Y equal 12.3/Y equal ${i}/g" md_temp.inp > md_temp_R${i}.inp
   mpirun -np ${NCPUs} ${lammps_adress}/lmp -in md_temp_R${i}.inp
   mv mol_sub.xyz mol_sub_R${i}.xyz
done
