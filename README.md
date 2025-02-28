# CP2k-v.9.1-examples


## CP2k installation (OS: Ubuntu, e.g., Ubuntu 22.04 LTS)

```
sudo apt update
sudo apt -y install cp2k
```


## Gnuplot installation
```
sudo apt -y install gnuplot
```


## Molden installation (this code requires academic)
- https://www.theochem.ru.nl/molden/howtoget.html
```
cd $HOME
wget https://ftp.science.ru.nl/Molden/molden7.3.tar.gz
tar zxvf molden7.3.tar.gz
cd molden7.3
sudo apt -y install gfortran build-essential libx11-6 libx11-dev libgl1-mesa-glx libgl1-mesa-dev mesa-common-dev libglu1-mesa-dev libxmu-dev xutils-dev wget
sed -i "s/FC = gfortran/FC = gfortran -std=legacy -ffixed-form -ffixed-line-length-none -w/g" makefile
make molden
```


## VMD (Version 1.9.2 (2014-12-29) Platforms: LINUX_64 OpenGL, CUDA)
- https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD
```
tar zxvf vmd-1.9.2.bin.LINUXAMD64.opengl.tar.gz
cd vmd-1.9.2
./configure LINUXAMD64
cd src
sudo make install
vmd
```


## VMD (Version 1.9.4 LATEST ALPHA (2022-04-27) Platforms: LINUX_64 (RHEL 7+) OpenGL, CUDA, OptiX RTX, OSPRay)
- https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD
```
tar zxvf vmd-1.9.4*
cd vmd-1.9.4a57
./configure LINUXAMD64
cd src
sudo make install
vmd
```
- check vmd adress: which vmd
- Another setting: ./configure LINUXAMD64 OPENGL FLTK TK LIBTACHYON NETCDF COLVARS TCL PYTHON PTHREADS NUMPY SILENT NOSTATICPLUGINS CXX11
- Since cp2k v.9.1 can only read one charmm file, please use "plugins/noarch/tcl/readcharmmtop1.1" from vmd-1.9.2.


## USCF Chimera (Free for non-commercial use)
- http://www.cgl.ucsf.edu/chimera/
- Info: https://ringo.ams.stonybrook.edu/index.php/Chimera
1. Quick Links -> Download
2. Linux 64-bit -> chimera-1.18-linux_x86_64.bin -> Accept
```
chmod +x chimera-1.18-linux_x86_64.bin
./chimera-1.18-linux_x86_64.bin
echo 'export PATH=$PATH:$HOME/.local/UCSF-Chimera64-1.18/bin' >> ~/.bashrc
bash
which chimera
```
- Open chimera command
```
chimera
```
- Note: Chimera is often used in "AMBER Tutorials (https://ringo.ams.stonybrook.edu/index.php/AMBER_Tutorials)". Sometimes preprocessing with Openbabel or reduce (AmberTools) doesn't work well. Therefore, it is good to be able to use Chimera.
- Note: Tutorial 1 – Getting Started with UCSF Chimera (https://www.youtube.com/watch?v=OHJD8tzigGo&list=PLHib7JgKNUUeTZONxd0h0WBiZzAJmXmva)
- PDB file format: https://www.wwpdb.org/documentation/file-format-content/format33/v3.3.html , https://pdbj.org/help/data-format


## Avogadro (https://avogadro.cc/ , https://github.com/cryos/avogadro)
1. sudo apt -y install avogadro
2. which avogadro
- It is 32 bit and can only handle small systems, but version 1.2.0 (https://sourceforge.net/projects/avogadro/) has an excellent user interface. The later version, Avogadro2, is difficult to use. There are cases where Avogadro2 is used for large systems. In most cases, I divide the structure and use Avogadro ver.1.2.0.


## Original files
- Basic: https://www.cp2k.org/howto
- QMMM, and NEB: https://www.cp2k.org/exercises


## EAM potential (required for QM/MM or NEB etc)
- Probably most of the potential at NIST (for Lammps) is not available in CP2k without converting the files.
- I couldn't get any other method than "QMMM/EAM_potential/cp2k_version" to work (I created a script to convert the EAM potential shown by NIST to CP2k version, but all of them failed).
- EAM_potential/cp2k_version: Cu, Ag, Au, Ni, Pd, Pt, Al, Pb, Fe, Mo, Ta, W, Mg, Co, Ti, Zr, and combinations of these.
- EAM 10000 points: EPS_SPLINE >= 1.7E-6
- EAM 20000 points: EPS_SPLINE >= 1.0E-7
- EAM 30000 points: EPS_SPLINE >= 1.7E-8
- EAM 40000 points: EPS_SPLINE >= 1.0E-8
- Number of EAM sample points and EPS_SPLINE reference value (if an error occurs, set EPS_SPLINE to a value larger than this value)
- Accuracy: DFT 1 meV, ReaxFF 43 meV. Typically, EAM should be considered worse than these accuracies.
- The score in EAM is specified by nr and nrho in Zhou04_create_v2.f. Just set nr and nrho to the same value. This github has 20,000 points. The "+1" is necessary so don't leave it out !
- As stated in NIST, the combinations shown above may not have been fully tested for all the elements, but they will be useful. Since you only need to let QS take care of the reactive parts, it is enough if the structure of the substrate you want, such as vacancies and element substitutions, is maintained.
- I don't know about ReaxFF, but EAM takes into account the concept of universal potential. In addition, it is important to remember that the concept of density functional theory is also included as an approximation of the second moment, and the influence of many-body effects is included.
- FCC is a close-packed structure, and the approximation of the spherical electron distribution is relatively good, so the structure can be reproduced even with Lennard-Jones. In Zhou's 2004 paper, Ca, Sr, Rh, and Ir were not prepared, so as an alternative, it would be good to construct the basic structure with Lennard-Jones.
- Elements that are easiest to reproduce the most stable structure using EAM (left) to elements that are difficult to reproduce (right): V,Ca,Na,Cr,Mn,Nb,Ir,Sr,Rh,Ru,Os,Hf,Re,Zn.
- This github does not provide examples of grain boundaries or vacancy defects. However, since EAM allows such calculations, it may be possible to consider them as substrate structures. I would like to see the passive state of Fe, Cr, O and Al, O addressed in QS to promote research. In addition, it is also important to compare and consider at low cost using ReaxFF in Lammps.
- We also added elements that have been verified in papers as pure metals (and may show relatively good results in HEA): V, Cr, Nb
- We have also added elements that have been published and verified as pure metals: Hf (for Hf-Cu)
- α-brass copper–zinc alloys: Zn (for Zn-Cu) (Note: Although the formula for calculating the parameters was explained, there were some unclear parts that I did not fully understand, so I am worried that the parameter values ​​I calculated based on the paper may be incorrect.)


## Tersoff potential (1988 and 1989)
- Tersoff potentials are available on this github. I haven't looked closely at the code in cp2k, so I assume it's the 1988 formula (Tersoff_1). Lammps seems to use the 1989 formula (Tersoff_2). The 1988 and 1989 papers use the same parameter values ​​for Si. Therefore, I decided to apply the same parameters for carbon (using those from NIST).
- The Tersoff potential can reproduce various crystal structures (dimer, graphite, diamond, SC, BCC, FCC). Compared with electronic structure calculations for Si, the Tersoff cohesive energy shows good agreement, and although it tends to overestimate bond lengths, it also shows good agreement for coordination numbers from 4 to 8. 
- Tersoff also takes into account the universal potential and the second moment approximation. In light of these results for silicon, it is not surprising that Dr. J. Tersoff published parameters for amorphous carbon in a 1988 paper.
- Since EAM does not take into account the angular dependence (MEAM has been proposed to solve this problem but has not yet been implemented in CP2k), it is necessary to use Tersoff. Therefore, even if it is difficult to reproduce a structure (especially BCC) using Zhou's 2004 EAM, please keep in mind that it may be possible to reproduce the structure using Tersoff. 
- potfit code (https://www.potfit.net/wiki/doku.php) allows you to fit potentials using the 1989 formula. Try fitting using the results of first-principles calculations. gamma -> beta, mu -> lambda2
- NIST has presented the Tersoff potential for Fe, Zn, In, and Al-C-Ti, which shows the wide range of applicability of the Tersoff potential. gamma-> beta, not use beta, and lambda3=0.0 (m can have any value for lambda3=0.0).
- If there is no description for parameters between A and B, use the values ​​of A for beta, c, d, h, and n. For B-A, use the values ​​of B. A B B = A(B,B) = A-B. B A A = B(A,A) = B-A. A B A = A(B,A) and A A B = A(A,B) often result in A(B,A)=A(A,B). e.g., https://www.ctcms.nist.gov/potentials/Download/1990--Tersoff-J--Si-C/1/1990_SiC.tersoff


## Morse potential
- The Morse potential is very suitable for calculating the vibrational structure of molecules. In particular, it can accurately model the strength of molecular bonds and vibrational energy levels. This is because it takes into account anharmonicity, which is closer to the behavior of real molecules than the harmonic oscillator model.
- Consideration of anharmonicity: The vibrations of real molecules are not perfectly harmonic, and the spacing between energy levels decreases with the vibrational quantum number. The Morse potential takes this anharmonicity into account.
- The Morse potential is also useful in ionic bond systems. In ionic bonds, the electron density distribution tends to be spherically symmetric, and the Morse potential can capture these characteristics well. In particular, it is useful for accurately predicting the energies of bond formation and dissociation.
- Bond dissociation: The Morse potential explicitly includes states in which bonds are broken (dissociated), so it can accurately express the dissociation energy of molecules.
- For these reasons, the Morse potential is widely used in the analysis of molecular vibrations and the study of bond breaking processes.
### Morse potential (Alkaline metals or alkaline earth metals)
- The electron density distribution of alkaline earth metals and alkali metals is close to spherical symmetry, so the directionality of the bonds has little effect on the physical properties. These metals mainly form ionic bonds and metallic bonds, and the strength and distance of the bonds are more important than the directionality of the bonds.
- The electron density distribution of alkaline earth metals and alkali metals tends to be spherical symmetric, so the directionality of the bonds has a relatively small effect on the physical properties. For this reason, in combination with these metals, the accuracy of the simulation is often maintained even if the angle dependency is ignored.


## Buckingham database
- https://www5.hp-ez.com/hp/calculations/page515


## Basis (ls /usr/share/cp2k)
- https://pierre-24.github.io/cp2k-basis/developers/library_content/
- https://cp2k-basis.pierrebeaujean.net/
- https://www.basissetexchange.org/
- https://github.com/cp2k/cp2k/tree/master/data
- https://www.cp2k.org/tools:cp2k-basis


## Videos
- https://www.youtube.com/@CP2K


## cp2k-examples (Pt.pot and Au.pot)
- https://github.com/cp2k/cp2k-examples
- https://manual.cp2k.org/trunk/methods/qm_mm/image_charges.html
- https://github.com/compchem-cybertraining/Tutorials_CP2K


## data/xc_section in CP2k github
- Copy and paste the text from "&XC" to "&END XC" in the *.sec file listed on github into the cp2k input file.


## Information
- cp2k_how_to: https://github.com/ishikawa-group/cp2k_how_to/tree/main (Japanese)
- https://doi.org/10.1021/acsami.4c11275 (CP2k and Lammps input)


## Preparing to run biomolecular QM/MM simulations with CP2K using AmberTools
- Movie: https://www.youtube.com/watch?v=zilybdb8x-A
- https://docs.bioexcel.eu/2020_06_09_online_ambertools4cp2k/
- https://docs.bioexcel.eu/2020_06_09_online_ambertools4cp2k/cp2k/index.html
- https://manual.cp2k.org/trunk/methods/qm_mm/builtin.html


## AmberTools information (Installation, etc)
- https://github.com/by-student-2017/AmberTools


## PC specs used for test
- OS: Microsoft Windows 11 Home 64 bit
- BIOS: 1.14.0
- CPU： 12th Gen Intel(R) Core(TM) i7-12700
- Base Board：0R6PCT (A01)
- Memory：32 GB
- GPU: NVIDIA GeForce RTX3070
- WSL2: VERSION="22.04.1 LTS (Jammy Jellyfish)"
- Python 3.10.12
- CP2k ver.9.1
