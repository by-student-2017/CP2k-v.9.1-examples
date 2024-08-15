from scipy.constants import physical_constants
import numpy as np
import random
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from ase.data import atomic_masses,atomic_numbers

n=1
T=298.15
#### CONSTANTS
kb=physical_constants['Boltzmann constant in eV/K'][0]
hartree=physical_constants['hartree-electron volt relationship'][0]
kb=kb/hartree
vau=physical_constants['atomic unit of velocity'][0]
bohr=physical_constants['Bohr radius'][0]
hartree_joule=physical_constants['hartree-joule relationship'][0]
amc=physical_constants['atomic mass constant'][0]
aum=physical_constants['atomic unit of mass'][0]
me=amc/aum
#### CONSTANTS
fig,ax1=plt.subplots(1,1,figsize=(10,10))

lab='T= {:6.2f} K'.format(T)
ax1.set_title('Maxwell-Boltzmann distribution of velocities $4\pi p^2 f(p)$',size=20)
ax1.tick_params(labelsize=20)
ax1.set_xlabel(r'$v \, \, in \, \,  m/s$',fontsize=20)
ax1.set_ylabel('Probability density [arb. units]',fontsize=20)
for element in ['He' ,'Ar','Xe']:
    xp=[]
    yp=[]
    m=atomic_masses[atomic_numbers[element]]
    m=m*me
    for i in range(1500):
        xp.append(i)
        p=m*float(i)/vau
        #y=4*np.pi*p*p*n/((2*np.pi*m*kb*T)**(+3/2))*np.exp(-p*p/(2*m*kb*T))
        y=1.0/(m*m)*4*np.pi*p*p*n*((m/(2*np.pi*kb*T))**(3./2.))*np.exp(-p*p/(2*m*kb*T))
        yp.append(y)

    ax1.plot(xp,yp,label=element,linewidth=3)
ax1.legend(loc="upper right")
plt.show()
fig.savefig("maxwell.png", dpi=200)
#ax1.clear()

