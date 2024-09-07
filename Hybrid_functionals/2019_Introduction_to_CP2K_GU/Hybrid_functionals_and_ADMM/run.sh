#!/bin/bash

cp2k_adress="/usr/bin"
NCPUs=8

export OMP_NUM_THREADS=1

#---------------------------------------------------------------------------------------------------

echo "1st task : GGA restart wfn"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water-GGA.inp | tee water-GGA.out
cp WATER-RESTART.wfn WATER-RESTART-GGA.wfn

#---------------------------------------------------------------------------------------------------

echo "2nd task: PBE0-D3 water"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water-PBE0-D3.inp | tee water-PBE0-D3.out
cp WATER-RESTART.wfn WATER-RESTART-PBE0-D3.wfn

#---------------------------------------------------------------------------------------------------

echo "3rd task"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water-PBE0-D3-cut.inp | tee water-PBE0-D3-cut.out

#---------------------------------------------------------------------------------------------------

echo "4rd task : introduce ADMM (Auxiliary Density Matrix Methods)"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water-PBE0-D3-ADMM.inp | tee water-PBE0-D3-ADMM.out
# https://www.cp2k.org/_media/events:2019_ghent:admm.pdf
# https://github.com/cp2k/cp2k/blob/master/data/BASIS_ADMM
# https://www.cp2k.org/_media/events:2015_cecam_tutorial:ling_hybrids.pdf

#---------------------------------------------------------------------------------------------------

echo "5th task : ionized water"
mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water-PBE0-D3-ADMM-ion.inp | tee water-PBE0-D3-ADMM-ion.out

#mpirun -np ${NCPUs} ${cp2k_adress}/cp2k -i water_pbe0_cheating.inp | tee water_pbe0_cheating.out

#---------------------------------------------------------------------------------------------------

#cat WATER-1.ener
#echo 'plot "./WATER-1.ener" u 2:5 w lp, "./WATER-1.ener" u 2:6 w lp' | gnuplot -p -
#vmd WATER-pos-1.xyz

#---------------------------------------------------------------------------------------------------