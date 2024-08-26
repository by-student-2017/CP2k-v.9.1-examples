#!/bin/bash

echo "started Equilibration on `date` "

do_parallel="sander"

prmtop="../003.tleap/2P16.wet.complex.prmtop"
coords="../004.equil/09.equil"

MDINPUTS=(10.prod)

for input in ${MDINPUTS[@]}; do
  
  ${do_parallel} -O -i ${input}.mdin -o ${input}.mdout -p ${prmtop} -c ${coords}.rst7 -ref ${coords}.rst7 -x ${input}.trj -inf ${input}.info -r ${input}.rst7
  coords=${input}
  
done
echo "Finished Equilibration on `date` "
