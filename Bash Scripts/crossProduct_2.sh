#!/bin/bash

function crossProduct {
    local -n v1=$1
    local -n v2=$2
    local result=()

    # You should remain to use bc because Bash only does integers. 
    result+=($( echo "(${v1[1]} * ${v2[2]}) - (${v1[2]} * ${v2[1]}) " | bc))
    result+=($( echo "-((${v1[0]} * ${v2[2]}) - (${v1[2]} * ${v2[0]}))" | bc ))
    result+=($( echo "(${v1[0]} * ${v2[1]}) - (${v1[1]} * ${v2[0]})" | bc ))
    echo "${result[@]}"
}

vect1[0]=0.3
vect1[1]=-0.3
vect1[2]=0.1

vect2[0]=0.4
vect2[1]=0.9
vect2[2]=2.3

vectResult=($(crossProduct vect1 vect2))
echo ${vectResult[0]} ${vectResult[1]} ${vectResult[2]}

dotProduct=$(echo "${vect1[0]}*${vectResult[0]}+${vect1[1]}*${vectResult[1]}+${vect1[2]}*${vectResult[2]}"|bc -l)
echo $dotProduct
