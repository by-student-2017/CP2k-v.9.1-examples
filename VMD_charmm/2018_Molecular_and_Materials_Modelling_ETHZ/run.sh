#!/bin/bash

lammps_adress="/usr/bin"
NCPUs=4

export OMP_NUM_THREADS=1

mpirun -np ${NCPUs} ${lammps_adress}/lmp -in md_temp.inp
