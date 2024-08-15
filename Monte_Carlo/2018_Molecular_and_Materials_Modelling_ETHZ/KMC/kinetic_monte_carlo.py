import matplotlib.pyplot as plt
import numpy as np
from scipy.constants import physical_constants
import time

def unique(l):
    newk = []
    for i in l:
        if i not in newk:
            newk.append(i)
    return newk

### periodic boundary conditions
def pbc(v,nx,ny):
    b=np.array(v)
    dim=len(b.shape)
    if dim==2:
        for a in v:
            if a[0] <0: 
                a[0]=a[0]+nx
            elif a[0] > nx  -1 :
                a[0]=a[0]-nx
            if a[1] <0: 
                a[1]=a[1]+ny
            elif a[1] > ny  -1:
                a[1]=a[1]-ny
    else:
        if v[0] <0: 
            v[0]=v[0]+nx
        elif v[0] > nx  -1 :
            v[0]=v[0]-nx
        if v[1] <0: 
            v[1]=v[1]+ny
        elif v[1] > ny  -1:
            v[1]=v[1]-ny
    return v

### map lattice system coordinate  to cartesian coordinates
def coordinates(m,dx,dy):
    x=[]
    y=[]
    c=[]
    for i in m:
       x.append(i[0]*dx+i[2]*dx/2)
       y.append(i[1]*dy-i[2]*dy/2)
       if i[3]==0:
           c.append('blue')
       else:
           c.append('red')
    return x,y,c

### list of possible events with reference to the lattice coordinate convention
### the forth index means unbound (0) or bound (1) molecule
def events(m,selection,nx,ny):
    allevents=[]
    set=[]
    #### list of first neighbors (relative position)
    set.append([[0,0,1,0],[1,0,0,0],[0,1,1,0],[-1,1,1,0],[-1,0,0,0],[-1,0,1,0]])
    set.append([[1,-1,-1,0],[1,0,0,0],[1,0,-1,0],[0,0,-1,0],[-1,0,0,0],[0,-1,-1,0]])

    for i in selection:
        le=[]
        #### consider only molecules that are not binded
        if m[i][3] == 0:

            #### the funcion neighbors returns "n" teh number of occupied
            #### 1st nb sites and "l"  implicit and explicit list of
            ####  the 1st nb sites occupied e.g. [[0,[3,3,0,0]],[5,[2,3,1,0]]]
            n,l=neighbors(m,i,nx,ny)
            ids=m[i][2]

            #### if there are no first neigh then 6 diffusions possible
            thepoint=np.array(m[i])
            if n==0: 
                tobeadded=pbc((thepoint + np.array(set[ids])).tolist(),nx,ny)
                involved=[i]
                for d in tobeadded:
                    le.append([[d],'d',involved]) 
                   #le=le+pbc(tobeadded,nx,ny)
                   #le=[c+['d']+involved for c in le]
            else:
                away=[0,1,2,3,4,5]
                dr=[]
                dstring='d'+str(n)
                if n==2:
                    ndist=np.abs(l[0][0]-l[1][0])
                    if ndist==1 or ndist==5:
                        drstring='drl'+str(n)
                    else:
                        drstring='dr'+str(n)
                else:
                    drstring='dr'+str(n)
                for nn in l:
                    ni=nn[0]
                    ns=nn[1]
                    away.remove(ni)

                    #### binding
                    involved=[i,m.index(ns)]
                    new1=list(m[i])
                    new1[3]=1
                    new2=list(ns)
                    new2[3]=1
                    le.append([[new1,new2],'b',involved])

                    #### diffusion around
                    for aw in [1,5]:
                        nsite=np.mod(ni+aw,6)
                        if nsite not in dr:
                            dr.append(nsite)
                for nn in l:
                    ni=nn[0]
                    if ni in dr:
                        dr.remove(ni)
                for nsite in dr:
                    if nsite in away:
                        away.remove(nsite)
                    aux=(thepoint + np.array(set[ids][nsite])).tolist()
                    aux=pbc(aux,nx,ny)
                    le.append([[aux],drstring,[i]])
                #### diffusion away
                for nsite in away:
                    dstring='d'+str(n)
                    aux=(thepoint + np.array(set[ids][nsite])).tolist()
                    aux=pbc(aux,nx,ny)
                    le.append([[aux],dstring,[i]])
        allevents=allevents+le
    return allevents



### compute the total rate of events
def total_rate(events,rates):
    R=np.sum([rates[i[1]] for i in events])
    
    return R

### select randomly an event from the list of possible events
def find_event(R,rates,events):
    sum__l=0
    rho1=np.random.random()
    target=rho1*R
    sum_l=rates[events[0][1]]
    if target<sum_l:
        the_event=events[0]
    else:
        for i in events[1:]:
            sum_U=sum_l+rates[i[1]]
            if target<sum_U:
                the_event=i
                break
            sum_l=sum_U
    return the_event


### neighbors of a molecule according to the lattice coordinate convention
def neighbors(a,id,nx,ny):
    nneig=0
    allneig=[]
    f=[]
    f.append([[0,0,1,0],[1,0,0,0],[0,1,1,0],[-1,1,1,0],[-1,0,0,0],[-1,0,1,0]])
    f.append([[1,-1,-1,0],[1,0,0,0],[1,0,-1,0],[0,0,-1,0],[-1,0,0,0],[0,-1,-1,0]])
    thepoint=np.array(a[id])
    ids=a[id][2]
    for n in range(6):
        theneig=(thepoint + np.array(f[ids][n])).tolist()
        theneig=pbc(theneig,nx,ny)
        alt1=list(theneig) 
        alt2=list(theneig) 
        alt1[3]=1 
        alt2[3]=0
        if alt1 in a:
            nneig=nneig+1
            allneig.append([n,alt1])
        if alt2 in a:
            nneig=nneig+1
            allneig.append([n,alt2])
    return nneig,allneig


### function to execute an event
def apply_event(molecules,selected_event,possible_events):
    new_positions=selected_event[0]
    tobeupdated=[]
    theinvolved=0
    id_involved=selected_event[2]
    for involved in id_involved:
        tobeupdated.append(involved)
        nu,lu=neighbors(molecules,involved,nx,ny)
        for ii in lu:
            theindex=molecules.index(ii[1])
            if theindex not in tobeupdated:
                tobeupdated.append(theindex)

    for involved in id_involved:
        molecules[involved]=new_positions[theinvolved]
        theinvolved=theinvolved+1

    theinvolved=0
    for involved in id_involved:
        nu,lu=neighbors(molecules,involved,nx,ny)
        for ii in lu:
            theindex=molecules.index(ii[1])
            if theindex not in tobeupdated:
                tobeupdated.append(theindex)
        theinvolved=theinvolved+1

    i_shift = 0
    oldevents=list(possible_events)
    for i_oe, oe in enumerate(possible_events):
        for tu in tobeupdated:
            if tu in oe[2]:
                del oldevents[i_oe+i_shift]   
                i_shift -= 1
                break
    possible_events=list(oldevents)

#    oldevents=list(possible_events)
#    for oe in possible_events:
#        for tu in tobeupdated:
#            if tu in oe[2]:
#                oldevents.remove(oe)
#                break
#    possible_events=list(oldevents)

    return possible_events,tobeupdated

#### PHYSICAL CONSTANTS
kb=physical_constants['Boltzmann constant in eV/K'][0]
#### END PHYSICAL CONSTANTS


#### SIZE OF THE BOX
nx=30
ny=nx/2
dx=13.5
sr3=np.sqrt(3.0)
dy=dx*sr3
#### END SIZE OF THE BOX

#### PLOTTING
dotsize=int(4000/nx)
ngraph=int(input("update graph each steps  "))
#### END PLOTTING

#### NUMBER OF MOLECULES
coverage=float(input("coverage "))
nmolecules=int(nx*nx*coverage)
#### END NUMBER OF MOLECULES

#### ENERGY PARAMETERS
nsteps=int(input("number of steps "))
T=float(input("temperature in K "))
db=float(input("diffusion barrier "))
bb=float(input("binding barrier "))
dd=db/20
Plot="True"
beta=1.0/(kb*T)
gamma_d=np.float64(10**10)
gamma_b=np.float64(10**8)

#### RATES OF EVENTS
rates={
'd' : gamma_d * np.exp(-beta*(db)) , \
'dr1': gamma_d * np.exp(-beta*(db)) , \
'dr2': gamma_d * np.exp(-beta*(db+dd)) , \
'drl2': gamma_d * np.exp(-beta*(db+1.5*dd)) , \
'dr3': gamma_d * np.exp(-beta*(db+3.0*dd)) , \
'dr4': gamma_d * np.exp(-beta*(db+3.0*dd)) , \
'dr5': gamma_d * np.exp(-beta*(db+6.0*dd)) , \
'd1': gamma_d * np.exp(-beta*(db+2*dd)) , \
'd2': gamma_d * np.exp(-beta*(db+4.0*dd)) , \
'd3': gamma_d * np.exp(-beta*(db+4*dd)) , \
'b':  gamma_b * np.exp(-beta*bb)\
}
print("RATES")
print(rates)
#### END ENERGY PARAMETERS

fig,(ax1)=plt.subplots(1,1,figsize=(10, 10))

param_str = "cov%.2f_nt%d_T%.0f_db%.2f_bb%.2f" % (coverage, nsteps, T, db, bb) 

### function for plotting
def update_plot(save):
    x,y,c=coordinates(molecules,dx,dy)
    plt.ion()
    ax1.set_title('time=%.2e s'%t)
    ax1.set_aspect(1)
    ax1.axes.set_xlim([0,nx*dx])
    ax1.axes.set_ylim([0,ny*dy])
    ax1.set_xlabel('nm')
    ax1.set_ylabel('nm')
    ax1.scatter(x,y,color=c,s=dotsize)
    plt.text(0.75, 0.86, "step nr: %d"%i, fontsize=14, transform=plt.gcf().transFigure)
    plt.show()
    plt.pause(0.01)
    if save:
        fig.savefig("step%d_%s.png"%(i, param_str), dpi=200)
    ax1.clear()

i=0
molecules=[]

#### Create initial geometry
while i < nmolecules :
   xi=np.random.randint(0,nx)
   yi=np.random.randint(0,ny)
   si=np.random.randint(0,2)
   newmolecule=[xi,yi,si,0]
   if  newmolecule  not in molecules:
       molecules.append(newmolecule)
       i=i+1
#### END Create initial geometry

#### MAIN KMC LOOP
t=0

#### at the beginning we have to check possible events for all molecules
tobeupdated=[iu for iu in range(len(molecules))]
possible_events=[]

acc_events_time = 0.0
acc_rate_time = 0.0
acc_1_time = 0.0
acc_2_time = 0.0
acc_else_time = 0.0
acc_plot_time = 0.0

for i in range(nsteps):
    ### timing for efficiency check
    time1 = time.time()

    ### create the list of possible events
    possible_events=possible_events+events(molecules,tobeupdated,nx,ny)
    if possible_events==[]:
       print("no more events possible")
       break

    acc_events_time += time.time() - time1
    time1 = time.time()

    ### compute the total rate of events (can be improved)
    R=total_rate(possible_events,rates)

    acc_rate_time += time.time() - time1
    time1 = time.time()

    ### select randomly an event
    selected_event=find_event(R,rates,possible_events)

    ### apply the event
    possible_events,tobeupdated=apply_event(molecules,selected_event,possible_events)

    ### evolve time according to Poisson distribution
    rho2=np.random.random()
    dt=-np.log(rho2)/R
    t=t+dt

    acc_else_time += time.time() - time1
    time1 = time.time()
    if Plot=="True":

        if i % ngraph == 0:
            update_plot(i % int(nsteps/4) == 0)

    acc_plot_time += time.time() - time1


update_plot(True)

#print("event time", acc_events_time)
#print("rate time", acc_rate_time)
#print("1 time", acc_1_time)
#print("2 time", acc_2_time)
#print("everything else", acc_else_time)
#print("plotting time", acc_plot_time)
