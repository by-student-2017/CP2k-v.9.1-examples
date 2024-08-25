#!/bin/bash

export OMP_NUM_THREADS=1

prm_file="../002.ANTE.TLEAP/1DF8.com.wat.leap.prm7"
rst_file="../002.ANTE.TLEAP/1DF8.com.wat.leap.rst7"

sander -O -i 01mi.in -o 01mi.out -p ${prm_file} -c ${rst_file} -ref ${rst_file} -x 01mi.trj -inf 01mi.info -r 01mi.rst7
sander -O -i 02md.in -o 02md.out -p ${prm_file} -c 01mi.rst7   -ref 01mi.rst7   -x 02md.trj -inf 02md.info -r 02md.rst7
sander -O -i 03mi.in -o 03mi.out -p ${prm_file} -c 02md.rst7   -ref 02md.rst7   -x 03mi.trj -inf 03mi.info -r 03mi.rst7
sander -O -i 04mi.in -o 04mi.out -p ${prm_file} -c 03md.rst7   -ref 03md.rst7   -x 04mi.trj -inf 04mi.info -r 04mi.rst7
sander -O -i 05mi.in -o 05mi.out -p ${prm_file} -c 04md.rst7   -ref 04md.rst7   -x 05mi.trj -inf 05mi.info -r 05mi.rst7
sander -O -i 06md.in -o 06md.out -p ${prm_file} -c 05mi.rst7   -ref 05mi.rst7   -x 06md.trj -inf 06md.info -r 06md.rst7
sander -O -i 07md.in -o 07md.out -p ${prm_file} -c 06mi.rst7   -ref 05mi.rst7   -x 07md.trj -inf 07md.info -r 07md.rst7
sander -O -i 08md.in -o 08md.out -p ${prm_file} -c 07mi.rst7   -ref 05mi.rst7   -x 08md.trj -inf 08md.info -r 08md.rst7
sander -O -i 09md.in -o 09md.out -p ${prm_file} -c 08mi.rst7   -ref 05mi.rst7   -x 09md.trj -inf 09md.info -r 09md.rst7
sander -O -i 10md.in -o 10md.out -p ${prm_file} -c 09mi.rst7   -ref 05mi.rst7   -x 10md.trj -inf 10md.info -r 10md.rst7
sander -O -i 11md.in -o 11md.out -p ${prm_file} -c 10mi.rst7   -ref 05mi.rst7   -x 11md.trj -inf 11md.info -r 11md.rst7

