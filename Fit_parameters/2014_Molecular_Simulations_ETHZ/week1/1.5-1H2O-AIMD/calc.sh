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
distance_OH2=$(calculate_distance ${O[0]} ${O[1]} ${O[2]} ${H2[0]} ${H2[1]} ${H2[2]})
echo "O-H2 Distance: $distance_OH2"
#echo ${distance_OH2} >> O-H.data

distance_HH=$(calculate_distance ${H1[0]} ${H1[1]} ${H1[2]} ${H2[0]} ${H2[1]} ${H2[2]})
echo "H1-H2 Distance: $distance_HH"
#echo ${distance_HH} >> H-H.data

# Calculate the angle (radian)
cos_theta=$(echo "($distance_OH1^2 + $distance_OH2^2 - $distance_HH^2)/ (2.0 * $distance_OH1 * $distance_OH2)" | bc -l)
sin_theta=$(echo "sqrt(1.0 - $cos_theta^2)" | bc -l)
tan_theta=$(echo "$sin_theta / $cos_theta" | bc -l)

# negative <= tan <= positive -> -PI()/2 <= atan <= PI()/2, -180 deg for negative cos() value.
theta_rad=$(echo "scale=10; a($tan_theta)" | bc -l)

# +180 deg
theta_deg=$(echo "180.0 + $theta_rad * 180.0 / (4.0*a(1.0))" | bc -l)

echo "H-O-H angle: $theta_deg"
echo ${theta_deg} >> H-O-H.data
echo "-----------------------------------------------"
