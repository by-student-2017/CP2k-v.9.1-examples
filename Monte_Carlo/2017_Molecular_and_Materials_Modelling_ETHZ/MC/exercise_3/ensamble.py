import numpy as np
import random
import matplotlib.pyplot as plt
import matplotlib.animation as animation



fig,(ax1,ax2)=plt.subplots(1,2,figsize=(10,5))
plt.ion()

na =int(raw_input("number of particles? "))
k=0.5 #eV/(A*A)
amax=2
m=np.array([[ 1 + 0.0*random.random()] for i in range(na)])
#v0=np.array([  3*random.random()] for i in range(na)])
a=np.array([[1.5+  0.0*random.random()] for i in range(na)]) 
w=np.sqrt(k/m)
t=np.array([i for i in range(150)])
dt=0.1
xi=np.linspace(-amax,amax,100)
yi=0.5*k*xi*xi
x=a*np.cos(w*t*dt)
p=0.5*np.sin(w*t*dt)
pp=np.sum(p,axis=0)/na
cm=np.sum(x,axis=0)/na
y=0.5*k*x*x
frames=[]
for i in range(100):
    artists = []
    ax1.set_title('harmonic oscillator')
    ax1.set_aspect(1)
    ax1.axes.set_xlim([-amax,amax])
    ax1.set_xlabel(r'$x$',fontsize=15)
    ax1.set_ylabel(r'$\frac{1}{2}kx^2$',fontsize=15)
    ax1.axes.set_ylim([0,k*amax*amax])
    artists.extend( ax1.plot(xi.tolist(),yi.tolist(),'b-') )
#   ax1.add_artist(plt.Circle((0.5,0.5), 0.5, color='r', fill=False, clip_on=True))
    for j in range (na):
        artists.append( ax1.scatter(x.tolist()[j][i],y.tolist()[j][i],s=40) )
#   ax1.legend(loc="upper right")
    ax2.set_title('phase space')
    ax2.set_xlabel(r'$q=x$',fontsize=15)
    ax2.set_ylabel(r'$p=mv$',fontsize=15)
    ax2.axes.set_xlim([-amax,amax])
    ax2.axes.set_ylim([np.amin(p),np.amax(p)])
    ax2.set_aspect(1)
    artists.append( ax2.scatter(cm.tolist()[:i],pp.tolist()[:i],color='red',s=40) )
    frames.append(tuple(artists))
    plt.show()
    plt.pause(0.1)
#    ax1.clear()
#    ax2.clear()
print(frames)
im_ani = animation.ArtistAnimation(fig, frames, interval=50, repeat_delay=3000,
                                   blit=True)
mfile = "ensamble.mp4"
print("Making movie {}".format(mfile))
writer = animation.FFMpegWriter(fps=15, metadata=dict(artist='Me'), bitrate=1800)
#writer = animation.MencoderWriter(fps=15, bitrate=1800)
im_ani.save(mfile, writer=writer)
