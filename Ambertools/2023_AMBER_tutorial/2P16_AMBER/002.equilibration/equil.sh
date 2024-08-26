#!/bin/bash

echo "Started Equilibration on `date` "

do_parallel="sander"

prmtop="../001.tleap_build/2P16.wet.complex.prmtop"
coords="../001.tleap_build/2P16.wet.complex"


MDINPUTS=(01.min 02.equil 03.min 04.min 05.min 06.equil 07.equil 08.equil 09.equil)

for input in ; do

  ${do_parallel} -O -i ${input}.mdin -o ${input}.mdout -p ${prmtop} -c ${coords}.rst7 -ref ${coords}.rst7 -x ${input}.trj -inf ${input}.info -r ${input}.rst7
  coords=${input}
done

echo "Finished Equilibration on `date` "
