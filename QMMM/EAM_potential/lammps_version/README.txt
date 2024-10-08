EAM database tool

Fortran version (create.f) by Xiaowang Zhou (Sandia), xzhou at sandia.gov
with revisions by Lucas Hale lucas.hale at nist.gov from https://www.ctcms.nist.gov/potentials/entry/2004--Zhou-X-W-Johnson-R-A-Wadley-H-N-G--Al/

Python version (create_eam.py) by Germain Clavier germain.clavier at gmail.com

Most parameters based on this paper:

X. W. Zhou, R. A. Johnson, and H. N. G. Wadley, Phys. Rev. B, 69,
144113 (2004).

Parameters for Cr were taken from:
m = 20, n = 20
Lin Z B, Johnson R A and Zhigilei L V, Phys. Rev. B 77 214108 (2008)
X. Yang et al., 2021.: https://www.researchgate.net/publication/348923109 (In this paper, confirmation is given for AlCoCrFe High Entropy Alloy.)
 Or (Only three main parameters are different: beta(ntypes)=beta1(ntypes), A(ntypes), B(ntypes))
For EAM_Cr_Anand-2016_code
G. Anand et al., Scripta Materialia, 124, 90-94 (2016).

Parameters for Nb were taken from:
m = 20, n = 20
De-Ye Lin et al., J. Phys.: Condens. Matter 25 (2013) 105404.

Parameters for Hf were taken from:
X. W. Zhou (2001) version
m = 20, n = 20
S. I. Rao et al., Acta. Mater. 209 (2021) 116758. (In this paper, confirmation is given for HfNbTaTiZr.)
 Or
For EAM_Hf-Sasikumar-2019.code
Maybe, m = 20, n = 20
K. Sasikumar et al., Chem. Mater. 2019, 31, 9, 3089-3102.

Parameters for V were taken from:
m = 20, n = 20
S. Zhao et al., Acta Materialia, 219, 117233 (2021).
In this paper, confirmation is given for BCC VTaTi and VTaW.

Parameters for Zn were taken from:
Maybe, m = 20, n = 20
A. Clement et al., Modelling Simul. Mater. Sci. Eng. 31 (2023) 015004
For Zn
re = a/sqrt(2) = 3.935/sqrt(2) = 2.78 [Angstrom](FCC case)
fe = Cohesive energy [eV/atom] / (Lattice parameter^3/4)^(1/3) [Angstrom/atom] = 0.43834 [eV/Angstrom]
rhos = rhoe = 6.84 [eV/Angstrom]
For Cu (Calculation for checking)
re = a/sqrt(2) = 3.635/sqrt(2) = 2.57 [Angstrom](FCC case)
fe = Cohesive energy [eV/atom] / (Lattice parameter^3/4)^(1/3) [Angstrom/atom] = 1.62206 [eV/Angstrom]
rhos = rhoe = 21.42 [eV/Angstrom]

This tool can be used to create an DYNAMO-formatted EAM
setfl file for alloy systems, using any combination
of the elements discussed in the paper and listed in
the EAM_code file, namely:

Cu, Ag, Au, Ni, Pd, Pt, Al, Pb, Fe, Mo, Ta, W, Mg, Co, Ti, Zr, Cr, Nb, Hf, V, Zn

WARNING: Please note that the parameter sets used here are all optimized
for the pure metals of the individual elements and that mixing rules will
be applied for creating the inter-element interactions.  Those are inferior
to models where the mixed terms were specifically optimized for particular
alloys.  Thus any potential files created with this tool should be used
with care and test calculations (e.g. on multiple binary mixtures) performed
to gauge the error.

Steps (create.f):

1) compile create.f -> a.out  (e.g. gfortran create.f)
2) edit the input file EAM.input to list 2 or more desired elements to include
3) a.out < EAM.input will create an *.eam.alloy potential file

Steps (create_eam.py):

Usage: create_eam.py [-h] [-n NAME [NAME ...]] [-nr NR] [-nrho NRHO]

options:
  -n NAME [NAME ...], --names NAME [NAME ...]
                        Element names
  -nr NR                Number of point in r space [default 2000]
  -nrho NRHO            Number of point in rho space [default 2000]

1) you must have numpy installed
2) run "python create_eam.py -n Ta Cu" with the list of desired elements
3) this will create an *.eam.alloy potential file

in DYNAMO or LAMMPS context the created file is referred to as a setfl file
  that can be used with the LAMMPS pair_style eam/alloy command
