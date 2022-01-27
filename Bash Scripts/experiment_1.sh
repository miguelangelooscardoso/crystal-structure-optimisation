#!/bin/bash
function crossProduct {
    local -n v1=$1
    local -n v2=$2
    local result=()

    # You should remain to use bc because Bash only does integers. 
    result+=($( echo "(${v1[1]} * ${v2[2]}) - (${v1[2]} * ${v2[1]}) " | bc ))
    result+=($( echo "-((${v1[0]} * ${v2[2]}) - (${v1[2]} * ${v2[0]}))" | bc ))
    result+=($( echo "(${v1[0]} * ${v2[1]}) - (${v1[1]} * ${v2[0]})" | bc ))
    echo "${result[@]}"
}
# Experimental Lattice Parameters (Zhang)
a_exp=`echo "5.22"|bc -l`
echo $a_exp
b_exp=`echo "sqrt(3)*5.22"|bc -l`
echo $b_exp
c_exp=`echo "4.24"|bc -l`
echo $c_exp
ca_exp=`echo "${c_exp}/${a_exp}"|bc -l`
echo $ca_exp
# V_exp was divided by 3
v_exp=`echo "(${a_exp})^2*${c_exp}*sqrt(3)/2"|bc -l` 
echo $v_exp

for i in 0.90 0.92 0.94 0.96 0.98 1.00 1.02 1.04 1.06 1.08 1.10; do
for j in 0.90 0.92 0.94 0.96 0.98 1.00 1.02 1.04 1.06 1.08 1.10; do
v=`echo "${i}*${v_exp}"|bc -l`
ca=`echo "${j}*${ca_exp}"|bc -l`
a=`echo "e((1/3)*l((2*${v})/(${ca}*sqrt(3))))"|bc -l`
b=`echo "sqrt(3)*${a}"|bc -l`
c=`echo " ${ca}*${a}"|bc -l`
echo $v
echo $ca
done
done 

# elements
ele_1=Fe
ele_2=Mn
ele_3=Ge
# lattice parameters
a=`echo "8.8007751822"|bc -l`
echo $a
b=`echo "sqrt(3)*$a"|bc -l`
echo $b
c=`echo "8.36073"|bc -l`
echo $c
# lattice ratios
ba=$(echo "$b/$a"|bc -l)
echo $ba
ca=$(echo "$c/$a"|bc -l)
echo $ca
declare -A arr
# first vector
arr1[0,0]=0.5
arr1[0,1]=`echo "-0.5*${ba}"|bc`
arr1[0,2]=0
#second vector
arr2[1,0]=0.5
arr2[1,1]=`echo "0.5*${ba}"|bc`
arr2[1,2]=0
#third vector
arr3[2,0]=0
arr3[2,1]=0
arr3[2,2]=$ca
echo "${arr1[0,0]} ${arr1[0,1]} ${arr1[0,2]}"  # example

vectResult=($(crossProduct arr2 arr3))
echo ${vectResult[0]} ${vectResult[1]} ${vectResult[2]}

dotProduct=$(echo "${arr1[0,0]}*${vectResult[0]}+${arr1[0,1]}*${vectResult[1]}+${arr1[0,2]}*${vectResult[2]}"|bc -l)
echo $dotProduct

pi=`echo "scale=10; 4*a(1)" | bc -l`

echo $pi

rws=`echo "e((1/3)*l((${dotProduct}*${a}^3)*(3/(8*4*${pi}))))"|bc -l`

echo $rws

rmt=`echo "0.85 * $rws"| bc`
echo $rmt

dx=`echo "l($rws / 0.000001) / 720.0" | bc -l`;
echo $dx
