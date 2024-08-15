import matplotlib.pyplot as plt
import numpy as np
from scipy.constants import physical_constants

#### this subroutine identifies all molecules connected to a given one
#### simple BUT NOT EFFICIENT
def allconnected(m,id,nx,ny):
    
    theconnected=[m[id]]
    n,l=neighbors(m,id,nx,ny)
    if n>0:
        remain=list(m) 
        remain.remove(m[id])
        for i in l:
            #theconnected.append(m[i])
            remain.remove(m[i])
        for i in l:
            remain.append(m[i])
            theconnected=theconnected+allconnected(remain,len(remain)-1,nx,ny)
            for j in theconnected:
                if j in remain:
                    remain.remove(j)

    return theconnected

def ene(mol,de,nx,ny):
    totene=0.0
    for m in range(len(mol)):
        n,l =neighbors(mol,m,nx,ny)
        totene=totene + n*de
    return totene/2

#### PERIODIC BOUNDARY CONTITIONS
def pbc(a,nx,ny):
    if a[0] <0: 
        a[0]=a[0]+nx
    elif a[0] > nx  -1 :
        a[0]=a[0]-nx
    if a[1] <0: 
        a[1]=a[1]+ny
    elif a[1] > ny  -1:
        a[1]=a[1]-ny
    return a

#### CONVERT the lattice coordinates in cartesian coordinates
#### used for plotting
def coordinates(m,dx,dy):
    x=[]
    y=[]
    for i in m:
       x.append(i[0]*dx+i[2]*dx/2)
       y.append(i[1]*dy-i[2]*dy/2)
    return x,y

#### find the 1st neighboring molecules to a given one
def neighbors(a,id,nx,ny):
    nneig=0
    allneig=[]
    thepoint=np.array(a[id])
    if a[id][2] == 0:
        for inc in [[0,0,1],[1,0,0],[0,1,1],[-1,1,1],[-1,0,0],[-1,0,1]]:
            theneig=(thepoint + np.array(inc)).tolist()
            theneig=pbc(theneig,nx,ny)
            if theneig in a:
                nneig=nneig+1
                allneig.append(a.index(theneig))
    else:
        for inc in [[1,-1,-1],[1,0,0],[1,0,-1],[0,0,-1],[-1,0,0],[0,-1,-1]]:
            theneig=(thepoint + np.array(inc)).tolist()
            theneig=pbc(theneig,nx,ny)
            if theneig in a:
                nneig=nneig+1
                allneig.append(a.index(theneig))
    return nneig,allneig

fig,(ax1,ax2,ax3)=plt.subplots(1,3,figsize=(15,5))
sr3=np.sqrt(3.0)
#### SIZE OF THE BOX
nx=50
ny=nx/2
dx=10.02
dy=dx*sr3
#### END SIZE OF THE BOX

#### PLOTTING
dotsize=int(1500/nx)
#### END PLOTTING

#### NUMBER OF MOLECULES and STEPS
coverage=float(input("coverage "))
nmolecules=int(nx*nx*coverage)
nouter=int(input("number of cycles "))
#### END NUMBER OF MOLECULES

#### ENERGY PARAMETERS
de=float(input("binding energy in eV "))
T=float(input("Temperature in K "))
kb=physical_constants['Boltzmann constant in eV/K'][0]
beta =1.0/(kb*T)
#### END ENERGY PARAMETERS

#### we use a inner loop for averages on quatitites difficult to compute
ninner=1000

#np.random.randint(0,nl)  0 is included nl is excluded

Plot="True"
molecules=[]
i=0

#### DEBUG
#molecules=[[12, 10, 1], [13, 10, 1], [13, 10, 0] , [12,10,0] ]
#print molecules
#print allconnected(molecules,0,nx,ny)
#print allconnected(molecules,1,nx,ny)
#print allconnected(molecules,2,nx,ny)
#exit()
#### END DEBUG

#### Create initial geometry
while i < nmolecules :
   xi=np.random.randint(0,nx)
   yi=np.random.randint(0,ny)
   si=np.random.randint(0,2)
   newmolecule=[xi,yi,si]
   if  newmolecule  not in molecules:
       molecules.append(newmolecule)
       i=i+1
#### END Create initial geometry

#### Initial energy
totene=0.0
for m in range(nmolecules):
    n,l =neighbors(molecules,m,nx,ny)
#   print molecules[m],n,l
    totene=totene + n*de
totene=totene/2
print("intial energy",totene)
test=ene(molecules,de,nx,ny)
print(test)
#### END Initial energy

x,y=coordinates(molecules,dx,dy)

#### Output file
out=open("data_%.2f_%.2f_%.0f.out"% (coverage, de, T),'w')
out.write("step_nr avg#alone avg#dimer avg#clusters\n")

dimers = []
clusters = []

nacc=0
nrej=0
avgene=0.0
plot_ene=[[0,totene,totene]]
alone_plot=[]
dimers_plot=[]
clusters_plot=[]

#### outer loop of the simulation
for i in range(nouter):
    if i > 1:
        theavgene=avgene/(ninner*(i-1))
        print("STEP %d; avg_energy: %.2f; total_energy: %.2f" % (i, theavgene, totene))
        plot_ene.append([i-1,theavgene,totene])
        x,y=coordinates(molecules,dx,dy)

        #### COUNT DIMERS and clusters
        nalone=0
        ndimer=0
        nclusters=0

        dimers = []
        clusters = []

        #### I will not check molecules already found in a cluster
        reduced=list(molecules)
        while len(reduced)>0:
            cluster=allconnected(reduced,0,nx,ny) 
            members=len(cluster)
            if   members==1:
                nalone=nalone+1
            elif members ==2:
                ndimer=ndimer+1
                dimers += cluster
            else:
                nclusters=nclusters+1
                clusters += cluster

            #### I will not check molecules already found in a cluster
            for c in cluster:
                reduced.remove(c)

        ####    UPDATE plotting of #dimers
        if i>2: 
            print("avg_alone ",alone_plot[i-3][2],"avg_dimers", \
               dimers_plot[i-3][2],"avg_clusters ",clusters_plot[i-3][2])
            out.write("%7d %9.2f %9.2f %12.2f\n"%(i, alone_plot[i-3][2], dimers_plot[i-3][2],clusters_plot[i-3][2]))

            alone_plot.append([i-1,nalone,np.mean(np.array(alone_plot)[:,1])])        
            dimers_plot.append([i-1,ndimer,np.mean(np.array(dimers_plot)[:,1])])        
            clusters_plot.append([i-1,nclusters,np.mean(np.array(clusters_plot)[:,1])])
        else:
            alone_plot.append([i-1,nalone,nalone])        
            dimers_plot.append([i-1,ndimer,ndimer])        
            clusters_plot.append([i-1,nclusters,nclusters])        
       ####   END  UPDATE plotting of #dimers

#### END COUNT DIMERS     


#### inner loop of 1000 steps
    for j in range(ninner):

       #### SELECT randomly a molecule and a new position
       selected = np.random.randint(0,nmolecules) 
       xn=np.random.randint(0,nx)
       yn=np.random.randint(0,ny)
       sn=np.random.randint(0,2)
       newmolecule=[xn,yn,sn]
       #### END SELECT randomly a molecule and a new position

       #### check that the new random position is not already occupied
       if  newmolecule not in molecules:
           oldmolecule=molecules[selected]
           n,l=neighbors(molecules,selected,nx,ny)
#          print "neig old",n
           eold=de*n
           molecules[selected]=newmolecule
           n,l=neighbors(molecules,selected,nx,ny)
#          print "neig new",n
           enew=de*n

#### DECIDE whether to accept or not the move
           deltae=enew - eold
           if np.random.random() < np.exp(-beta*deltae) :
                nacc=nacc+1
                totene=totene+deltae
           else:                         #cancel the move
                nrej=nrej+1
                molecules[selected]=oldmolecule
#          print oldmolecule,newmolecule
#          print deltae,totene,ene(molecules,de,nx,ny)
#          print molecules
#### DECIDE whether to accept or not the move


#### STATISTICS
           if i>0:
               avgene=avgene+totene
#### END STATISTICS


    
    if Plot=="True":


        x_dimer,y_dimer=coordinates(dimers,dx,dy)
        x_cluster,y_cluster=coordinates(clusters,dx,dy)

        plt.ion()
        ax1.set_title('particles')
        ax1.set_aspect(1)
        ax1.axes.set_xlim([0,nx*dx])
        ax1.axes.set_ylim([0,ny*dy])
        ax1.set_xlabel('nm')
        ax1.set_ylabel('nm')
        ax1.scatter(x,y,s=dotsize)
        ax1.scatter(x_dimer,y_dimer,color='r',s=dotsize)
        ax1.scatter(x_cluster,y_cluster,color='g',s=dotsize)
        ax2.set_title('#dimers & \#clusters')
        ax2.axes.set_xlim([0,nouter])
        ax2.axes.set_ylim([0,nmolecules])

        for plot, color, label in zip([alone_plot, dimers_plot, clusters_plot],
                                      ['b', 'r', 'g'],
                                      ["isolated", "dimers", "clusters"]):
            if len(plot) == 0:
                continue
            np_plot = np.array(plot)
            ax2.plot(np_plot[:, 0], np_plot[:, 1], linestyle='--', color=color)
            ax2.plot(np_plot[:, 0], np_plot[:, 2], linestyle='-', color=color, label=label)

        ax2.legend(loc="upper right")
        ax2.set_xlabel('# outer steps')
#       ax2.set_aspect(1)
        ax3.set_title('energies')
#       ax3.set_aspect(1)
        ax3.axes.set_xlim([0,nouter])
        if de == 0.0:
            ax3.axes.set_ylim([-0.01,0.01])
        else:
            ax3.axes.set_ylim([nmolecules*3.0*de,0])
        ax3.set_xlabel('# outer steps')
        ax3.set_ylabel('eV')
        np_plot_ene = np.array(plot_ene)
        ax3.plot(np_plot_ene[:, 0], np_plot_ene[:, 1],'b-',label='avg')
        ax3.plot(np_plot_ene[:, 0], np_plot_ene[:, 2],'r--')
        plt.show()
        plt.pause(0.01)
        if i in [2, int(nouter/2), nouter-1]:
            fig.savefig("plots_%.2f_%.2f_%.0f_%d.png" % (coverage, de, T, i), dpi=200)
        ax1.clear()
        ax2.clear()
        ax3.clear()

out.close()
