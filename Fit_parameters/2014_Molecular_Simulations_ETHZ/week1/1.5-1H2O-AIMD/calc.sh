#!/bin/bash

# Specify the file name
filename="coordinates.txt"

# Read the coordinates
read_coordinates() {
    local line_number=$1
    sed -n "${line_number}p" $filename | awk '{print $2, $3, $4}'
}

# Calculate Euclidean distance
calculate_distance() {
    local x1=$1
    local y1=$2
    local z1=$3
    local x2=$4
    local y2=$5
    local z2=$6
    echo "sqrt(($x2 - $x1)^2 + ($y2 - $y1)^2 + ($z2 - $z1)^2)" | bc -l
}

# Calculate the dot product of vectors
dot_product() {
    local x1=$1
    local y1=$2
    local z1=$3
    local x2=$4
    local y2=$5
    local z2=$6
    echo "$x1 * $x2 + $y1 * $y2 + $z1 * $z2" | bc -l
}

# Calculate the magnitude of a vector
magnitude() {
    local x=$1
    local y=$2
    local z=$3
    echo "sqrt($x^2 + $y^2 + $z^2)" | bc -l
}

# Read the coordinates
O=($(read_coordinates 3))
H1=($(read_coordinates 4))
H2=($(read_coordinates 5))

# Calculate the distance from O-H1
distance_OH1=$(calculate_distance ${O[0]} ${O[1]} ${O[2]} ${H1[0]} ${H1[1]} ${H1[2]})
echo "O-H1 Distance: $distance_OH1"
echo ${distance_OH1} >> O-H.data

## Calculate the distance from O-H2
#distance_OH2=$(calculate_distance ${O[0]} ${O[1]} ${O[2]} ${H2[0]} ${H2[1]} ${H2[2]})
#echo "O-H2 Distance: $distance_OH2"
#echo ${distance_OH2} >> O-H.data

# Calculate vectors OH1 and OH2
vector_OH1=($(echo "${H1[0]} - ${O[0]}" | bc -l) $(echo "${H1[1]} - ${O[1]}" | bc -l) $(echo "${H1[2]} - ${O[2]}" | bc -l))
vector_OH2=($(echo "${H2[0]} - ${O[0]}" | bc -l) $(echo "${H2[1]} - ${O[1]}" | bc -l) $(echo "${H2[2]} - ${O[2]}" | bc -l))

# Calculate the dot product and magnitude
dot_product_OH1_OH2=$(dot_product ${vector_OH1[0]} ${vector_OH1[1]} ${vector_OH1[2]} ${vector_OH2[0]} ${vector_OH2[1]} ${vector_OH2[2]})
magnitude_OH1=$(magnitude ${vector_OH1[0]} ${vector_OH1[1]} ${vector_OH1[2]})
magnitude_OH2=$(magnitude ${vector_OH2[0]} ${vector_OH2[1]} ${vector_OH2[2]})

# Calculate the angle (radian)
cos_theta=$(echo "$dot_product_OH1_OH2 / ($magnitude_OH1 * $magnitude_OH2)" | bc -l)
theta_rad=$(echo "a($cos_theta)" | bc -l)

# Calculate the angle (theta)
theta_deg=$(echo "$theta_rad * 180 / 4*a(1)" | bc -l)
if (( $(echo "$theta_deg < 0" | bc -l) )); then
    theta_deg=$(echo "90 - $theta_deg" | bc -l)
fi
echo "H-O-H angle: $theta_deg"
echo ${theta_deg} >> H-O-H.data
echo "-----------------------------------------------"