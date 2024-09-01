#!/bin/bash

# Usage
# 1. chmod +x dynamo2cp2.sh
# 2. ./dynamo2cp2.sh

echo "-----------------------------------------------------------------"

if [ -z "$1" ]; then
  echo "not read ./dynamo2cp2.sh *.eam.alloy command"
  echo "auto read EAM potential file"
  filename=`find *eam.alloy`
else
  filename=$1
fi
echo "Read EAM file: "${filename}

echo "-----------------------------------------------------------------"

# Read the 4th line
line4=$(sed -n '4p' "${filename}")
# Read the 5th line
line5=$(sed -n '5p' "${filename}")

# Convert space-separated string to array
read -a array_elem <<< "${line4}"
read -a array_mesh <<< "${line5}"

Nrho=${array_mesh[0]}
drho=${array_mesh[1]}
Nr=${array_mesh[2]}
dr=${array_mesh[3]}
cutoff=${array_mesh[4]}

echo "-----------------------------------------------------------------"
echo "Number of elements: "${array_elem[0]}
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"

Ls=6
awk -v Ls=${Ls} '{if(NR==Ls){print $0}}' ${filename}
natm=("0")
mass=("0")
latt=("0")
new_natm=`awk -v Ls=${Ls} '{if(NR==Ls){printf "%d",$1}}' ${filename}`
new_mass=`awk -v Ls=${Ls} '{if(NR==Ls){printf "%f",$2}}' ${filename}`
new_latt=`awk -v Ls=${Ls} '{if(NR==Ls){printf "%f",$3}}' ${filename}`
natm+=("${new_natm}")
mass+=("${new_mass}")
latt+=("${new_latt}")
# Display the contents of an array
i=1
for element in "${array_elem[@]}"; do
    if [ "${element}" == "${array_elem[0]}" ]; then
      continue
    fi
    #
    echo "-------------------------------------------"
    echo "${i}: ${element} , F(r): embedding function F(rho) (Nrho values)"
    #
    awk -v Ls=${Ls} -v Nrho=${Nrho} '{
      if(Ls<NR && NR<=Ls+Nrho){printf "%24.16e \n",$1}
    }' ${filename} > Frho_Nrho_${element}.txt
    #
    echo "Linear Interpolation version"
    awk -v Nrho=${Nrho} -v Nr=${Nr} -v drho=${drho} 'BEGIN{
      #printf "%24.16e %24.16e \n",0.0,0.0
      o1=0.0; n0=0.0; n1=0.0; i=1 ; Ls=1
    }{
      if(NR<=Nr){
        o1=n0; n0=n1; i=i+1; n1=$1
      }
      if(2<NR && NR<=Nr){
        if(3==NR){
          dFrho=(n1 - n0)/drho
          printf "%24.16e %24.16e \n",n0-dFrho*drho,dFrho
        }
        dFrho=(n1 - o1)/(2.0*drho)
        printf "%24.16e %24.16e \n",n0,dFrho
      }
    }END{
      dFrho=(n1 - o1)/(2.0*drho)
      for (i = Nrho; i <= Nr; i++){
        Frho = n1 + dFrho*drho
        printf "%24.16e %24.16e \n",Frho,dFrho
      }
    }' Frho_Nrho_${element}.txt > Frho_Nr_${element}.txt
    #
    echo "-------------------------------------------"
    echo "${i}: ${element} , density function rho(r) (Nr values)"
    #
    Ls=$((${Ls} + ${Nrho}))
    awk -v Ls=${Ls} -v Nr=${Nr} -v dr=${dr} 'BEGIN{
      #printf "%24.16e %24.16e \n",0.0,0.0
      o1=0.0; n0=0.0; n1=0.0
    }{
      if(Ls<NR && NR<=Ls+Nr){
        o1=n0; n0=n1; n1=$1
      }
      if(Ls+2<NR && NR<=Ls+Nr){
        if(Ls+3==NR){
          drho=(n1 - n0)/dr
          printf "%24.16e %24.16e \n",n0-drho*dr,drho
        }
        drho=(n1 - o1)/(2.0*dr)
        printf "%24.16e %24.16e \n",n0,drho
      }
    }END{
      drho=(n1 - n0)/dr
      printf "%24.16e %24.16e \n",n1,drho
    }' ${filename} > rho_Nr_${element}.txt
    #
    if [ "${element}" == "${array_elem[-1]}" ]; then
        break
    fi
    #
    echo "-----------------------------------------------------------------"
    echo "-----------------------------------------------------------------"
    Ls=$((${Ls} + ${Nr} + 1))
    awk -v Ls=${Ls} '{if(NR==Ls){print $0}}' ${filename}
    new_natm=`awk -v Ls=${Ls} '{if(NR==Ls){printf "%d",$1}}' ${filename}`
    new_mass=`awk -v Ls=${Ls} '{if(NR==Ls){printf "%f",$2}}' ${filename}`
    new_latt=`awk -v Ls=${Ls} '{if(NR==Ls){printf "%f",$3}}' ${filename}`
    natm+=("${new_natm}")
    mass+=("${new_mass}")
    latt+=("${new_latt}")
    #
    i=$((${i} + 1))
done

echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
for ((i=1; i<=${array_elem[0]}; i++)); do
  for ((j=1; j<=i; j++)); do
    echo "(${i}, ${j}) = (${array_elem[${i}]},${array_elem[${j}]}) , pair potential phi(r) (Nr values)"
    Ls=$((${Ls} + ${Nr}))
    awk -v Ls=${Ls} -v Nr=${Nr} -v dr=${dr} 'BEGIN{
      #printf "%24.16e %24.16e \n",0.0,0.0
      o1=0.0; n0=0.0; n1=0.0; i=1
    }{
      if(Ls+1==NR){
        o1=n0; n0=n1; i=i+1; n1=$1/dr
      }
      if(Ls+1<NR && NR<=Ls+Nr){
        o1=n0; n0=n1; i=i+1; n1=$1/((i-1)*dr)
      }
      if(Ls+2<NR && NR<=Ls+Nr){
        if(Ls+3==NR){
          dphi = (n1 - n0)/dr
          printf "%24.16e %24.16e \n",n0-dphi*dr,dphi
        }
        dphi = (n1 - o1)/(2.0*dr)
        printf "%24.16e %24.16e \n",n0,dphi
      }
    }END{
      dphi=(n1-n0)/dr
      printf "%24.16e %24.16e \n",n1,dphi
    }' ${filename} > phi_Nr_${array_elem[${i}]}_${array_elem[${j}]}.txt
    #
    if [ "${i}" -ne "${j}" ]; then
      cp phi_Nr_${array_elem[${i}]}_${array_elem[${j}]}.txt phi_Nr_${array_elem[${j}]}_${array_elem[${i}]}.txt
    fi
  done
done

echo "-----------------------------------------------------------------"
if [ ! -d "results" ]; then
  mkdir results
fi
echo "-----------------------------------------------------------------"
for ((i=1; i<=${array_elem[0]}; i++)); do
  for ((j=1; j<=${array_elem[0]}; j++)); do
  #for ((j=1; j<=i; j++)); do
    echo "(${i}, ${j}) = (${array_elem[${i}]},${array_elem[${j}]}) , make EAM potential for CP2k in results directory"
    output="./results/${array_elem[${i}]}-${array_elem[${j}]}.eam.alloy"
    echo "title" > ${output}
    echo "${natm[${i}]}  ${mass[${i}]}  ${latt[${i}]}" >> ${output}
    echo "${dr}  ${drho}  ${cutoff}  ${Nr}" >> ${output}
    paste -d ' ' Frho_Nr_${array_elem[${i}]}.txt Frho_Nr_${array_elem[${j}]}.txt >> ${output}
    paste -d ' '  rho_Nr_${array_elem[${i}]}.txt  rho_Nr_${array_elem[${j}]}.txt >> ${output}
    paste -d ' '  phi_Nr_${array_elem[${i}]}_${array_elem[${i}]}.txt phi_Nr_${array_elem[${i}]}_${array_elem[${j}]}.txt >> ${output}
  done
done
echo "-----------------------------------------------------------------"

if [ ! -d "tmp" ]; then
  mkdir tmp
fi
mv *.txt ./tmp/

