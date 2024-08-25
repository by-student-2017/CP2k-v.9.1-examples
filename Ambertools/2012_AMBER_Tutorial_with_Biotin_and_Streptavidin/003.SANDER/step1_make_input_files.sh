#!/bin/bash

echo "#----- 01mi.in -----#"
cat << EOF1 > 01mi.in
01mi.in: minimization
&cntrl
  imin = 1, maxcyc = 1000, ntmin = 2,
  ntx = 1, ntc = 1, ntf = 1,
  ntb = 1, ntp = 0,
  ntwx = 1000, ntwe = 0, ntpr = 1000,
  cut = 8.0,
  ntr = 1,
  restraintmask = ':1-119 & !@H=',
  restraint_wt=5.0,
/
EOF1

echo "#----- 02md.in -----#"
cat << EOF2 > 02md.in
02md.in: equilibration (500000 = 0.1ns)
&cntrl
  imin = 0, ntx = 1, irest = 0, nstlim = 50000,
  temp0 = 298.15, tempi = 298.15, ig = 71287,
  ntc = 2, ntf = 1, ntt = 1, dt = 0.001,
  ntb = 2, ntp = 1, tautp = 1.0, taup = 1.0,
  ntwx = 500, ntwe = 0, ntwr = 500, ntpr = 500,
  cut = 8.0, iwrap = 1,
  ntr = 1, nscm = 100,
  restraintmask = ':1-119 & !@H=',
  restraint_wt = 5.0,
/
EOF2

echo "#----- 03mi.in -----#"
sed -e "s/restraint_wt=5.0/restraint_wt=2.00/g" 01mi.in > 03mi.in
sed -i "s/01mi.in/03mi.in/g" 03mi.in

echo "#----- 04mi.in -----#"
sed -e "s/restraint_wt=5.0/restraint_wt=0.10/g" 01mi.in > 04mi.in
sed -i "s/01mi.in/04mi.in/g" 04mi.in

echo "#----- 05mi.in -----#"
sed -e "s/restraint_wt=5.0/restraint_wt=0.05/g" 01mi.in > 05mi.in
sed -i "s/01mi.in/05mi.in/g" 05mi.in

echo "#----- 06md.in -----#"
cat << EOF6 > 06md.in
06md.in: equilibration (500000 = 0.1ns)
&cntrl
  imin = 0, ntx = 1, irest = 0, nstlim = 50000,
  temp0 = 298.15, tempi = 298.15, ig = 71287,
  ntc = 2, ntf = 1, ntt = 1, dt = 0.001,
  ntb = 2, ntp = 1, tautp = 1.0, taup = 1.0,
  ntwx = 1000, ntwe = 0, ntwr = 1000, ntpr = 1000,
  cut = 8.0, iwrap = 1,
  ntr = 1, nscm = 100,
  restraintmask = ':1-119 & !@H=',
  restraint_wt = 1.0,
/
EOF6

echo "#----- 07md.in -----#"
sed -e "s/restraint_wt=1.0/restraint_wt=0.50/g" 06md.in > 07md.in
sed -i "s/06md.in/07md.in/g" 07md.in

echo "#----- 08md.in -----#"
cat << EOF8 > 08md.in
08md.in: equilibration (500000 = 0.1ns)
&cntrl
  imin = 0, ntx = 1, irest = 0, nstlim = 50000,
  temp0 = 298.15, tempi = 298.15, ig = 71287,
  ntc = 2, ntf = 1, ntt = 1, dt = 0.001,
  ntb = 2, ntp = 1, tautp = 1.0, taup = 1.0,
  ntwx = 1000, ntwe = 0, ntwr = 1000, ntpr = 1000,
  cut = 8.0, iwrap = 1,
  ntr = 1, nscm = 100,
  restraintmask = ':1-118@CA,C,N',
  restraint_wt = 0.1,
/
EOF8

echo "#----- 09md.in -----#"
cp 08md.in 09md.in

echo "#----- 10md.in -----#"
cat << EOF10 > 10md.in
10md.in: production (500000 = 1ns)
&cntrl
  imin = 0, ntx = 5, irest = 1, nstlim = 500000,
  temp0 = 298.15, tempi = 298.15, ig = 71287,
  ntc = 2, ntf = 1, ntt = 1, dt = 0.002,
  ntb = 2, ntp = 1, tautp = 1.0, taup = 1.0,
  ntwx = 500, ntwe = 0, ntwr = 500, ntpr = 500,
  cut = 8.0, iwrap = 1,
  ntr = 1, nscm = 100,
  restraintmask = ':1-118@CA,C,N', restraint_wt = 0.1,
/
EOF10

echo "#----- 11md.in -----#"
cp 10md.in 11md.in

