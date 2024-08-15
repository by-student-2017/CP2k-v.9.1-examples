import numpy as np
import random
import matplotlib.pyplot as plt
import matplotlib.animation as animation
nin=0
nout=0
fig,ax1=plt.subplots(1,1,figsize=(10,10))
#fig = plt.figure(figsize=(10,10))
plt.ion()
xp=[]
yp=[]
ims=[]
for i in range (100000):
#   ax1=fig.subplots(111)
#   x=np.random.random_sample()
#   y=np.random.random_sample()
    x=random.random()
    y=random.random()
    xp.append(x)
    yp.append(y)
    d=(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)
    if d > 0.5*0.5:
        nout=nout+1
    else:
        nin=nin+1
    lab='value of $\pi$= {:6.3f} steps {:8d}'.format(float(4*nin)/(nin+nout), i)
    if np.mod(i,4000)==0:
        print i
        ax1.set_title('value of $\pi$',size=30)
        ax1.set_aspect(1)
        ax1.axes.set_xlim([0,1])
        ax1.axes.set_ylim([0,1])
        ax1.tick_params(labelsize=20)
        ax1.add_artist(plt.Circle((0.5,0.5), 0.5, color='r',lw=5, fill=False, clip_on=True))
        thelabel=ax1.text(0.5,-0.1,lab,fontsize=20,bbox={'facecolor':'red', 'alpha':1.0, 'pad':10})
        #im=ax1.scatter(xp,yp,s=1,label=lab)
        im=ax1.scatter(xp,yp,s=1)
        #ax1.legend(loc="upper right")
        #im=plt.show() 
        #ims.append(im)
        ims.append((im,thelabel ))
        plt.show()
        plt.pause(0.1)
        #ax1.clear()

im_ani = animation.ArtistAnimation(fig, ims, interval=50, repeat_delay=3000,
                                   blit=True)
mfile = "pi.mp4"
print("Making movie {}".format(mfile))
writer = animation.FFMpegWriter(fps=15, metadata=dict(artist='Me'), bitrate=1800)
#writer = animation.MencoderWriter(fps=15, bitrate=1800)
im_ani.save(mfile, writer=writer)
