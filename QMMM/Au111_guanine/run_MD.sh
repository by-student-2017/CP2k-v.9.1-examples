#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i Au_gua_image_dampFunc_MD.inp | tee Au_gua_image_dampFunc_MD.out
