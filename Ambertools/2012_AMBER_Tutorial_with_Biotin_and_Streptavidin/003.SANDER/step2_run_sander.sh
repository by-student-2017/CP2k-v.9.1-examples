#!/bin/bash

export OMP_NUM_THREADS=1

prm_file="../002.ANTE.TLEAP/1DF8.com.wat.leap.prm7"
rst_file="../002.ANTE.TLEAP/1DF8.com.wat.leap.rst7"

No="01"; echo "#----- ${No}mi.in -----#"; date
sander -O -i ${No}mi.in -o ${No}mi.out -p ${prm_file} -c ${rst_file} -ref ${rst_file} -x ${No}mi.trj -inf ${No}mi.info -r ${No}mi.rst7

preNo=${No}; No="02"; echo "#----- run ${No}md.in, read ${preNo} file -----#"; date
sander -O -i ${No}md.in -o ${No}md.out -p ${prm_file} -c ${preNo}mi.rst7 -ref ${preNo}mi.rst7 -x ${No}md.trj -inf ${No}md.info -r ${No}md.rst7

preNo=${No}; No="03"; echo "#----- run ${No}mi.in, read ${preNo} file -----#"; date
sander -O -i ${No}mi.in -o ${No}mi.out -p ${prm_file} -c ${preNo}md.rst7 -ref ${preNo}md.rst7 -x ${No}mi.trj -inf ${No}mi.info -r ${No}mi.rst7

preNo=${No}; No="04"; echo "#----- run ${No}mi.in, read ${preNo} file -----#"; date
sander -O -i ${No}mi.in -o ${No}mi.out -p ${prm_file} -c ${preNo}mi.rst7 -ref ${preNo}mi.rst7 -x ${No}mi.trj -inf ${No}mi.info -r ${No}mi.rst7

preNo=${No}; No="05"; echo "#----- run ${No}mi.in, read ${preNo} file -----#"; date
sander -O -i ${No}mi.in -o ${No}mi.out -p ${prm_file} -c ${preNo}mi.rst7 -ref ${preNo}mi.rst7 -x ${No}mi.trj -inf ${No}mi.info -r ${No}mi.rst7

preNo=${No}; No="06"; echo "#----- run ${No}md.in, read ${preNo} file -----#"; date
sander -O -i ${No}md.in -o ${No}md.out -p ${prm_file} -c ${preNo}mi.rst7 -ref ${preNo}mi.rst7 -x ${No}md.trj -inf ${No}md.info -r ${No}md.rst7

preNo=${No}; No="07"; echo "#----- run ${No}md.in, read ${preNo} file -----#"; date
sander -O -i ${No}md.in -o ${No}md.out -p ${prm_file} -c ${preNo}md.rst7 -ref 05mi.rst7 -x ${No}md.trj -inf ${No}md.info -r ${No}md.rst7

preNo=${No}; No="08"; echo "#----- run ${No}md.in, read ${preNo} file -----#"; date
sander -O -i ${No}md.in -o ${No}md.out -p ${prm_file} -c ${preNo}md.rst7 -ref 05mi.rst7 -x ${No}md.trj -inf ${No}md.info -r ${No}md.rst7

preNo=${No}; No="09"; echo "#----- run ${No}md.in, read ${preNo} file -----#"; date
sander -O -i ${No}md.in -o ${No}md.out -p ${prm_file} -c ${preNo}md.rst7 -ref 05mi.rst7 -x ${No}md.trj -inf ${No}md.info -r ${No}md.rst7

preNo=${No}; No="10"; echo "#----- run ${No}md.in, read ${preNo} file -----#"; date
sander -O -i ${No}md.in -o ${No}md.out -p ${prm_file} -c ${preNo}md.rst7 -ref 05mi.rst7 -x ${No}md.trj -inf ${No}md.info -r ${No}md.rst7

preNo=${No}; No="11"; echo "#----- run ${No}md.in, read ${preNo} file -----#"; date
sander -O -i ${No}md.in -o ${No}md.out -p ${prm_file} -c ${preNo}md.rst7 -ref 05mi.rst7 -x ${No}md.trj -inf ${No}md.info -r ${No}md.rst7

echo "#----- The Ende ----#"; date
