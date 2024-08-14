#!/bin/bash

lammps_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

echo "#AVG: Time, c_yforce, TotEng, PotEng, c_temp_molecule, Temp, KinEng, E_vdwl, Press, Enthalpy" > pot_mean_force.dat

# from 12.3 to 12.5, 0.1 step
for i in $(seq 12.3 0.1 12.5)
do
   sed "s/Y equal 12.3/Y equal ${i}/g" md_temp.inp > md_temp_R${i}.inp
   mpirun -np ${NCPUs} ${lammps_adress}/lmp -in md_temp_R${i}.inp
   
   bash get_pot_mean_force.sh
   
   mv mol_sub.xyz mol_sub_R${i}.xyz
   mv TCB_PMF.restart TCB_PMF_R${i}.restart
   mv log.lammps log_R${i}.lammps
done

echo "plot 'pot_mean_force.dat' using 2:10 w p,'pot_mean_force.dat' using 2:10 sm acs lw 1; set xlabel 'yforce / (kcal mol^{-1} Angstrom^{-1})' ; set ylabel 'Enthalpy / (kcal mol^{-1})' ; pause mouse" |  gnuplot
