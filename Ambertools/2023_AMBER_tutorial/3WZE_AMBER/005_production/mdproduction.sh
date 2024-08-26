#!/bin/bash

echo "started Equilibration on `date` "

do_parallel="sander"

parm7="../003_leap/3wze.wet.complex.parm7"
coords="../004_equil/09.equil"

MDINPUTS=( 10.prod )

for input in ${MDINPUTS[@]}; do
  
  $do_parallel -O -i ${input}.mdin -o ${input}.mdout -p ${parm7} -c ${coords}.rst7 -ref ${coords}.rst7 -x ${input}.trj -inf ${input}.info -r ${input}.rst7
  coords=
  
done
echo "Finished Equilibration on `date` "
