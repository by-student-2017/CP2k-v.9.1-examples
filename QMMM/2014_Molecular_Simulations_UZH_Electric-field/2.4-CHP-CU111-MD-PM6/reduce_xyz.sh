#!/bin/bash

# Usage
# 1. chmod +x reduce_xyz.sh
# 2. ./reduce_xyz.sh case.xyz 40.0 40.0 30.0

# Specify the input and output files
input_file=$1
output_file="reduced_"${input_file}

# Specify the parameters of the cubic cell
a=$2
b=$3
c=$4

# Initialize the output file
> $output_file

# Use awk to process the input file and reduce the coordinates
awk -v a="$a" -v b="$b" -v c="$c" '
{
    if ($1 ~ /^[A-Za-z]/) {
        x = (($2+a) % a)
        y = (($3+b) % b)
        z = (($4+c) % c)
        printf "%s %.6f %.6f %.6f\n", $1, x, y, z
    } else if ($0 ~ /i =/ && $0 ~ /time =/ && $0 ~ /E =/) {
        print $0
    } else {
        print $0
    }
}' $input_file > $output_file

echo "Transformation complete. Output file: $output_file"