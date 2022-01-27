#!/bin/bash
function crossProduct {
    local -n v1=$1
    local -n v2=$2
    local result=()

    # You should remain to use bc because Bash only does integers. 
    result+=($( echo "(${v1[1]} * ${v2[2]}) - (${v1[2]} * ${v2[1]}) " | bc))
    result+=($( echo "-((${v1[0]} * ${v2[2]}) - (${v1[2]} * ${v2[0]}))" | bc))
    result+=($( echo "(${v1[0]} * ${v2[1]}) - (${v1[1]} * ${v2[0]})" | bc))
    echo "${result[@]}"
}

# elements
ele_1=Fe
ele_2=Mn
ele_3=Ge
# lattice parameters
a=`echo "8.8007751822"|bc`
b=`echo "sqrt(3)*$a"|bc`
c=`echo "0.9499996779"|bc`
# lattice ratios
ba=`echo "b/a"|bc`
ca=`echo "c/a"|bc`

declare -A arr
# first vector
arr1[0,0]=0.5
arr1[0,1]=-0.5*$ba
arr1[0,2]=0
#second vector
arr2[1,0]=0.5
arr2[1,1]=0.5*$ba
arr2[1,2]=0
#third vector
arr3[2,0]=0
arr3[2,1]=0
arr3[2,2]=$ca
echo "${arr1[0,0]} ${arr1[0,1]} ${arr1[0,2]}"  # example

vectResult=($(crossProduct arr2 arr3))
echo ${vectResult[0]} ${vectResult[1]} ${vectResult[2]}

dotProduct=`echo "${arr1[0]}*${vectResult[0]}+${arr1[1]}*${vectResult[1]}+${arr1[2]}*${vectResul$
echo $dotProduct

pi=`echo "scale=10; 4*a(1)" | bc -l`

rws=`echo "((${dotProduct}*${a}^3)*(3/(8*4*${pi})))^(1/3)"|bc`
echo ${a}
echo${pi}

