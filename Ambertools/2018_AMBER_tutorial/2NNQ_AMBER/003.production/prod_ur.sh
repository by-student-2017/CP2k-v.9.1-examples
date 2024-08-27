#!/bin/bash

echo "started Equilibration on `date` "

do_parallel="sander"

parm7="../001.tleap_build/2nnq.wet.complex.parm7"
coords="../002.equilbration/09.equil"

MDINPUTS=(10.prod_ur)

for input in ${MDINPUTS[@]}; do
  
  ${do_parallel} -O -i ${input}.mdin -o ${input}.mdout -p ${parm7} -c ${coords}.rst7 -ref ${coords}.rst7 -x ${input}.trj -inf ${input}.info -r ${input}.rst7
  coords=${input}
  
done
echo "Finished Equilibration on `date` "
