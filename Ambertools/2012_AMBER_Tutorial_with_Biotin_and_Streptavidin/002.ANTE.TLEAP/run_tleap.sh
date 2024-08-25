#!/bin/bash

echo "#----- run tleap.lig.in -----#"
tleap -s -f tleap.lig.in | tee tleap.lig.out

echo "#----- run tleap.rec.in -----#"
tleap -s -f tleap.rec.in | tee tleap.rec.out

echo "#----- run tleap.com.in -----#"
tleap -s -f tleap.com.in | tee tleap.com.out

echo "#----- please, check output (prm and rst) file -----#"
ls -ltra

