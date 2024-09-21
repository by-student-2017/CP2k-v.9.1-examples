#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_FCC111.in | tee md_dftb_FCC111.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_BCC110.in | tee md_dftb_BCC110.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_HCP0001.in | tee md_dftb_HCP0001.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_gra0001_tersoff.in | tee md_dftb_gra0001_tersoff.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_dia100_tersoff.in | tee md_dftb_dia100_tersoff.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_BCC110_tersoff-zbl.in | tee md_dftb_BCC110_tersoff-zbl.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_Zincblende100_tersoff.in | tee md_dftb_Zincblende100_tersoff.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_Zincblende100_tersoff-charge.in | tee md_dftb_Zincblende100_tersoff-charge.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_C-dia100_tersoff.in | tee md_dftb_C-dia100_tersoff.out

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i md_dftb_CwH-dia100_tersoff.in | tee md_dftb_CwH-dia100_tersoff.out
