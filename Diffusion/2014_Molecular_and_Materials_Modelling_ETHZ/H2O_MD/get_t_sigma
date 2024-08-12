#!/bin/bash
# calculates average and variance of the 4th column of a file
grep -v '#' $1 | \
      awk '{c=c+1;x=x+$4;x2=x2+($4)^2}END{print "average=",x/c,"sigma=",sqrt(x2/c-(x/c)^2)}'
