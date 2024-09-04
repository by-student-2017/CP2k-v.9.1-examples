#!/bin/bash
#------------------------------------------------------------
input_file="run-1H2O-AIMD.xyz"

output_prefix="coordinates"

n=5
#------------------------------------------------------------
if [ -d "data" ]; then
  rm -rf data
fi
mkdir data
#------------------------------------------------------------
echo "distance(O-H)" > O-H.data
echo "angle(H-O-H)" > H-O-H.data
#------------------------------------------------------------
counter=1
line_counter=0
output_file="${output_prefix}_${counter}.txt"
while IFS= read -r line; do
    
    line_counter=$((line_counter + 1))
    
    echo "$line" >> "$output_file"
    
    if (( line_counter % n == 0 )); then
        counter=$((counter + 1))
        output_file="./data/${output_prefix}_${counter}.txt"
    fi
done < "$input_file"

cd data
#------------------------------------------------------------
#!/bin/bash

for file in *.txt; do
  echo "Processing $file"
  cp $file coordinates.txt
  bash ./../calc.sh
done

cp O-H.data ./../
cp H-O-H.data ./../

cd ..
#------------------------------------------------------------