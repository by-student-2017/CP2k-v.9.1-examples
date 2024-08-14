#!/bin/bash

awk '{if($1=="Loop"){i=0};if(i==1){print $0};if($1=="Time"){print "#"$0;i=1}}' log.lammps > data.dat

tail -n 100 data.dat | awk 'BEGIN{i=0}
{
  i=i+1
  Time += $1
  c_yforce += $2
  TotEng += $3
  PotEng += $4
  c_temp_molecule += $5
  Temp   += $6
  KinEng += $7
  E_vdwl += $8
  Press  += $9
  Enthalpy += $10
}
END{
  Time /= i
  c_yforce /= i
  TotEng /= i
  PotEng /= i
  c_temp_molecule /= i
  Temp /= i
  KinEng /= i
  E_vdwl /= i
  Press /= i
  Enthalpy /= i
  print(Time, c_yforce, TotEng, PotEng, c_temp_molecule, Temp, KinEng, E_vdwl, Press, Enthalpy)
}' >> pot_mean_force.dat

rm -f data.dat