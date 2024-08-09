#!/bin/bash

for file in $(find ./ -type f -name "*.UPF"); do
    echo "Processing $file"
    python ./upf/upf_to_json.py $file
done
