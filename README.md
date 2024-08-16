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


## Original files
- Basic: https://www.cp2k.org/howto
- QMMM, and NEB: https://www.cp2k.org/exercises


## EAM potential (required for QM/MM or NEB etc)
- Probably most of the potential at NIST (for Lammps) is not available in CP2k without converting the files.


## Basis
- https://pierre-24.github.io/cp2k-basis/developers/library_content/
- https://cp2k-basis.pierrebeaujean.net/
- https://www.basissetexchange.org/
- https://github.com/cp2k/cp2k/tree/master/data
- https://www.cp2k.org/tools:cp2k-basis


## Buckingham database
- https://www5.hp-ez.com/hp/calculations/page515


## Videos
- https://www.youtube.com/@CP2K


## data/xc_section in CP2k github
- Copy and paste the text from "&XC" to "&END XC" in the *.sec file listed on github into the cp2k input file.


## Information
- cp2k_how_to: https://github.com/ishikawa-group/cp2k_how_to/tree/main (Japanese)


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
