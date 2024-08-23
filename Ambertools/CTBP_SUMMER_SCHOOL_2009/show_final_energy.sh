#!/bin/bash

# Define the file to read
file=*min.out

# Extract the ENERGY value
energy=$(awk '/ENERGY/{getline; print $2}' $file)

# Print the ENERGY value
echo "Energy, E [kcal/mol] units ?"
echo "$energy"

