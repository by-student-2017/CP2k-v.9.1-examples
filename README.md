# CP2k-v.9.1-examples


## CP2k installation (OS: Ubuntu)

```
sudo apt update
sudo apt -y install cp2k
```


## gnuplot installation
```
sudo apt -y install gnuplot
```


## molden installation
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


## Original files
- Basic: https://www.cp2k.org/howto
- QMMM, and NEB: https://www.cp2k.org/exercises


## QM/MM
- Probably most of the potential at NIST (for Lammps) is not available in CP2k without converting the files.


## Basis
- https://pierre-24.github.io/cp2k-basis/developers/library_content/
- https://cp2k-basis.pierrebeaujean.net/
- https://www.basissetexchange.org/
- https://github.com/cp2k/cp2k/tree/master/data
- https://www.cp2k.org/tools:cp2k-basis


## Videos
- https://www.youtube.com/@CP2K


## PC specs used for test
- OS: Microsoft Windows 11 Home 64 bit
- BIOS: 1.14.0
- CPU： 12th Gen Intel(R) Core(TM) i7-12700
- Base Board：0R6PCT (A01)
- Memory：32 GB
- GPU: NVIDIA GeForce RTX3070
- WSL2: VERSION="22.04.1 LTS (Jammy Jellyfish)"
- Python 3.10.12
