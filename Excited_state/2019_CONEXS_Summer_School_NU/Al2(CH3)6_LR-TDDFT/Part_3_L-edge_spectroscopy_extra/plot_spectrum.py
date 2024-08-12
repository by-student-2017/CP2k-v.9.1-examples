#This script aims at plotting a spectrum out of a XAS_TDP *.spectrum file
#
#Run as:
#
#python plot_spectrum.py   filename  atom_kind  donor_type  width  emin  emax  npts  excitation_type
#
#where: filename is the *.spectrum output file
#       atom_kind is the name of the excited atomic kind of interest
#       donor_type is the type of donor MO (1s, 2s, 2p)
#       width parameter for the gaussian broadening
#       emin the start of the x-axis in eV
#       emax the end of the x-axis in eV
#       npts number of points for the smooth spectrum 
#       excitation_type singlet, triplet, spin-conserving, ... (default singlet)


import sys
import numpy as np
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import math

#Reading the arguments
filename = sys.argv[1]
atom_kind = sys.argv[2]
donor_type = sys.argv[3]
width = float(sys.argv[4])
emin = float(sys.argv[5])
emax = float(sys.argv[6])
npts = int(sys.argv[7])
try:
    excitation_type = sys.argv[8]
except IndexError:
    excitation_type = "singlet"

#Reading the *.spectrum file
energy = []
fdip = []
do_type = False
ex_type = False
at_kind = False

with open(filename, "r") as myfile:

    for line in myfile:

        if not len(line.split()):
            continue

        #If the line starts with XAS TDP, need to look at the excitation_type and donor_type
        if line.startswith("XAS TDP"):
            if donor_type in line:
                do_type = True
            else:
                do_type = False

            if excitation_type in line:
                ex_type = True
            else:
                ex_type = False

        #If line starts woth "from EXCITED ATOM" then look for atomic kind
        if line.startswith("from EXCITED ATOM"):
            if atom_kind in line:
                at_kind = True
            else:
                at_kind = False

        parts = line.split()
        if ex_type and do_type and at_kind and parts[0].isdigit():
            energy.append(float(parts[1]))
            fdip.append(float(parts[2]))

    energy = np.array(energy)
    fdip = np.array(fdip)

#Doing the gaussian broadening
x = np.linspace(emin, emax, npts)
y = np.zeros(npts)

for i in range(len(energy)):
        y = y + fdip[i]/(width*np.sqrt(2.*math.pi))*np.exp(-0.5*((x-energy[i])/width)**2)

#Plotting the figure
plt.figure()
plt.plot(x,y)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.xlabel("Energy (eV)", fontsize=14)
plt.ylabel("Absorption (arb. units)", fontsize=14)
title = atom_kind+","+donor_type+"_"+excitation_type
plt.title(title.replace("_"," ")+" XAS spectrum.", fontsize=16)
plt.savefig(title+".png", format="png")
