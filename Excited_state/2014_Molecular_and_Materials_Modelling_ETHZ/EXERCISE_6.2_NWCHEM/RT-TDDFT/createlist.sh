#!/bin/bash

mkdir Cubes
mv density_subgs.*0.cube ./Cubes
rm density_subgs.*[1-9].cube
#rm *ao_re*

cat header.animate.cube.vmd > animate.cube.vmd
i=0
for a in ./Cubes/density_subgs.*0.cube; do
if (( i == 0 ))
then
  echo "set updmol [mol new {$a} type cube waitfor all] " > listfiles
else
 echo "mol addfile {$a} type cube waitfor all" >> listfiles
fi
i=$[$i+1]
done
cat listfiles >> animate.cube.vmd
cat footer.animate.cube.vmd >> animate.cube.vmd
