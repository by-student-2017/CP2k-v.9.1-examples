#!/bin/bash

echo "Started Analysis on `date` "
#do_parallel="mpirun pmemd.MPI"

cpptraj -p ../../001.tleap_build/2P16.wet.complex.prmtop -i cpptraj.hbond.in

echo "Finished Analysis on `date` "
