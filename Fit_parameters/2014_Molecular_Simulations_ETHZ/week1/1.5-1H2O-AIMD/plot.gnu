#!/bin/bash/gnuplot

datafile="data"

binwidth=0.005
bin(x,width)=width*floor(x/width)

plot datafile using (bin($2,binwidth)):(1.0) smooth freq with boxes

pause -1