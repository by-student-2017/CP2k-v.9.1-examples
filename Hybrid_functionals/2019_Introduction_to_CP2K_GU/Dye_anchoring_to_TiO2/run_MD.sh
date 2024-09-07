#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mode1.inp | tee mode1.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mode1_dye.inp | tee mode1_dye.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mode1_slab.inp | tee mode1_slab.out

#git clone https://github.com/cp2k/cp2k.git
#cd cp2k/tools/cubecruncher
#make
#cd ./../../../
#./cp2k/tools/cubecruncher/cubecruncher.x -i MODE1-ELECTRON_DENSITY-1_0.cube -subtract MODE1_dye-ELECTRON_DENSITY-1_0.cube -o tmp.cube
#./cp2k/tools/cubecruncher/cubecruncher.x -i tmp.cube -subtract MODE1_slab-ELECTRON_DENSITY-1_0.cube -center geo -o MODE1_delta.cube

#VESTA MODE1_delta.cube 

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mode2.inp | tee mode2.out

#echo "MODE1, E(slab-dye-complex)"
#grep "ENERGY|" mode1.out

#echo "MODE1, E(dye)"
#grep "ENERGY|" mode1_dye.out

#echo "MODE1, E(slab)"
#grep "ENERGY|" mode1_slab.out

#echo "MODE2, E(slab-dye-complex)"
#grep "ENERGY|" mode2.out

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mode1_MD.inp | tee mode1_MD.out

mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i mode2_MD.inp | tee mode2_MD.out
