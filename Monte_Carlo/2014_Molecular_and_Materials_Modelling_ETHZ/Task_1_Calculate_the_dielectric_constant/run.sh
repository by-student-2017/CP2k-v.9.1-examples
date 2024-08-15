#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=3

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mc_exercise.inp | tee mc_exercise.out

chmod +x calc_dielectric_constant.py
python ./calc_dielectric_constant.py 200 tmc_trajectory_T200.00.dip_cl