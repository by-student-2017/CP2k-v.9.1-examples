#!/bin/bash

echo "started Equilibration on `date` "

do_parallel="sander"

parm7="../03.leap/1s19.wet.complex.parm7"
coords="../04.equil/09.equil"

MDINPUTS=(10.prod)

for input in ${MDINPUTS[@]}; do
  
  ${do_parallel} -O -i ${input}.mdin -o ${input}.mdout -p ${parm7} -c ${coords}.rst7 -ref ${coords}.rst7 -x ${input}.trj -inf ${input}.info -r ${input}.rst7
  coords=${input}
  
done
echo "Finished Equilibration on `date` "
