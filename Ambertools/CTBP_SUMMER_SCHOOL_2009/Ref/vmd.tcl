# vmd-1.9.4, tcl command
# usage: vmd -e vmd.tcl PDB.pdb

menu main on
menu graphics on

mol modselect 0 0 protein
mol modcolor 0 0 Structure
mol modstyle 0 0 Cartoon 2.1 24.0 5.0

mol addrep 0
mol modselect 1 0 resname SUS
mol modcolor 1 0 Type
mol modstyle 1 0 VDW 1.0 12.0

mol addrep 0
mol modselect 2 0 water
mol modcolor 2 0 Name
mol modstyle 2 0 CPK 1.0 0.3 12.0 12.0

mol addrep 0
mol modselect 3 0 protein
mol modcolor 3 0 ColorID 22
mol modmaterial 3 0 Transparent
mol modstyle 3 0 QuickSurf 1.6 0.5 1.0 1.0

#axes location Off

display projection Orthographic

#display depthcue off

#color Display Background white
