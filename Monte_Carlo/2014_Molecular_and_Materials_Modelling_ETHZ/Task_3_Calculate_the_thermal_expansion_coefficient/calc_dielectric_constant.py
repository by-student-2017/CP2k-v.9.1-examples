#!/usr/bin/env python

import sys
import numpy as np

if(len(sys.argv) < 3):
    print("Usage: calc_dielectric_constant.py <temperature> <traj_1.dip_cl> ... <traj_N.dip_cl>")
    sys.exit()

T = float(sys.argv[1])
print("Temperature: %.2f K"%T)

weights = []; M_vec = []; cell_vol = []
for fn in sys.argv[2:]:
    print("Reading: "+fn)
    assert(fn.endswith(".dip_cl"))
    raw_data = np.loadtxt(fn) # [C*Angstrom]
    weights.append(raw_data[1:,0]-raw_data[:-1,0])
    M_vec.append(raw_data[:-1,1:4])
    cell_vol.append(np.loadtxt(fn.replace(".dip_cl", ".cell"), usecols=(10,)))

weights = np.concatenate(weights)
M_vec = np.concatenate(M_vec)
cell_vol = np.concatenate(cell_vol)

V = np.mean(cell_vol) # [Angstrom^3]
print("Total number of samples: %d"%np.sum(weights))
print("Mean cell volume: %.2f Angstrom^3"%V)

M = np.sqrt(np.sum(np.square(M_vec), axis=1)) # take norm of dipol moment
var = np.average(np.square(M), weights=weights) - np.square(np.average(M, weights=weights))

epsilon_0 = 8.8541878176e-12 #[F/m] vacuum permittivity
e = 1.602176565e-19 # [C] elementary charge
kb = 1.3806488e-23 #[J/K] Boltzmann constant
angstrom2meter = 1e-10
s = (e*e*4*np.pi)/(3*V*kb*T*angstrom2meter*epsilon_0)

epsilon = 1 + s*var
print("Dielectric constant: %.2f"%epsilon)