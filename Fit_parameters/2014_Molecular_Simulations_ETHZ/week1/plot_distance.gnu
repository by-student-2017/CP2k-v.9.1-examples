#!/bin/bash/gnuplot

datafile="O-H.data"

binwidth=0.005
bin(x,width)=width*floor(x/width)

plot datafile using (bin($1,binwidth)):(1.0) smooth freq with boxes

pause -1