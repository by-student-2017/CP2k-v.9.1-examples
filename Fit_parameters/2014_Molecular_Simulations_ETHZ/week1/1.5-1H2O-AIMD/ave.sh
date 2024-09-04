#!/bin/bash

awk '{sum += $1; count++} END {if (count > 0) printf "average (H-O-H angle): %f [degree] \n", sum / count}' H-O-H.data

awk '{sum += $1; count++} END {if (count > 0) printf "average (O-H distance): %f [Angstrom] \n", sum / count}' O-H.data
