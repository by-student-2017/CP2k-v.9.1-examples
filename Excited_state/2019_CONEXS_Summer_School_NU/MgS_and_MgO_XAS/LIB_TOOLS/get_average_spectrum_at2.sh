#!/bin/bash

DIR=`pwd`
SCRIPT_DIR=${DIR}/../../LIB_TOOLS # need rewrite it in your environment

echo "modify the loop below to include the files for which you want to compute the XAS spectrum"

for i in $(ls ${DIR}/*xas_at2*spectrum)
do
sed '/Absorption/d' ${i} > ${i}.temp
nlines=`wc -l ${i} | awk '{print $1}'`
done

echo "get an average spectrum for all atoms"

#module load gcc
gfortran ${SCRIPT_DIR}/my_convolute.f90 -o ${SCRIPT_DIR}/convolute.x
chmod 755 ${SCRIPT_DIR}/convolute.x

${SCRIPT_DIR}/average_files.sh *spectrum.temp > ${DIR}/spectrum.inp
lines=`wc -l spectrum.inp`

rm ${DIR}/*spectrum.temp


${SCRIPT_DIR}/convolute.x  -pnt ${lines} 



echo "--------------------------------------------------------------------------------------------"
echo " convoluted XAS spectrum by giving the number of lines of the spectrum (-pnt),"
echo " the energy of the first (K-edge) peak (-e1) up to which the gaussian width (-smin)"
echo " is increased linearly to mimic the experimental broadening of the excited states."
echo " possible values for smin are between 0.2 and 0.5."
echo " When running the convolution script try to adjust the energy of the first noticeable peak,"
echo " i.e. the K-edge peak, with the -e1 tag and the minimum gaussian width with -smin"
echo "--------------------------------------------------------------------------------------------"



