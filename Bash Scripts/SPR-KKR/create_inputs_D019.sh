#!/bin/bash
# Create .pot SCF.inp and JXC.inp D019 Fe2MnGe
SPRPATH=/home/mcardoso

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

# elements
ele_1=Fe
ele_2=Mn
ele_3=Ge

# Experimental Lattice Parameters (angstrom [Å]) (Zhang)
a_exp=`echo "5.22"|bc -l`
echo $a_exp
b_exp=`echo "sqrt(3)*${a_exp}"|bc -l`
echo $b_exp
c_exp=`echo "4.24"|bc -l`
echo $c_exp

# Experimental Lattice Parameters (atomic units of length [a.u.])
a_exp=`echo "1.8897259885789*${a_exp}"|bc -l`
echo $a_exp
b_exp=`echo "1.8897259885789*${b_exp}"|bc -l`
echo $b_exp
c_exp=`echo "1.8897259885789*${c_exp}"|bc -l`
echo $c_exp

# V_exp was divided by 3
v_exp=`echo "(${a_exp})^2*${c_exp}*sqrt(3)/2"|bc -l` 
echo $v_exp

# Experimental Lattice ratios
ba_exp=$(echo "${b_exp}/${a_exp}"|bc -l)
echo $ba_exp
ca_exp=$(echo "${c_exp}/${a_exp}"|bc -l)
echo $ca_exp

for i in 0.90 0.92 0.94 0.96 0.98 1.00; do

# New Volume
v=`echo "${i}*${v_exp}"|bc -l`
echo $v
mkdir v=${i}v_exp
cd v=${i}v_exp 

for j in 1.00; do

# New ratio c/a
ca=`echo "${j}*${ca_exp}"|bc -l`
echo $ca
mkdir ca=${j}ca_exp
cd ca=${j}ca_exp

# New lattice parameters
a=`echo "e((1/3)*l((2*${v})/(${ca}*sqrt(3))))"|bc -l`
echo $a
b=`echo "sqrt(3)*${a}"|bc -l`
echo $b
c=`echo " ${ca}*${a}"|bc -l`
echo $c

# ratio b/a
ba=`echo "${ba_exp}"|bc -l`
echo $ba

declare -A arr
# first vector
arr1[0,0]=0.5
arr1[0,1]=`echo "0.5*${ba}"|bc`
arr1[0,2]=0
#second vector
arr2[1,0]=-0.5
arr2[1,1]=`echo "0.5*${ba}"|bc`
arr2[1,2]=0
#third vector
arr3[2,0]=0
arr3[2,1]=0
arr3[2,2]=${ca}
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
# Cartesian sites 1st  and 2nd  were placed directly but there is an expression that defines
# its positions https://www.cryst.ehu.es/cgi-bin/cryst/programs/nph-wp-list 
# and M.J. Mehl et al. / Computational Materials Science 136 (2017) S1–S828
# however it does not depends on a or c, 2nd depends only on the ratio b/a and a constant 

cat >${ele_1}2${ele_2}${ele_3}.pot<<!
*******************************************************************************
HEADER    'SCF-start data created by xband  Thu Dec 19 15:38:04 WET 2019'
*******************************************************************************
TITLE     'SPR-KKR calculation for ${ele_1}2${ele_2}${ele_3}'
SYSTEM    ${ele_1}2${ele_2}${ele_3}
PACKAGE   SPRKKR
FORMAT    6  (21.05.2007)
*******************************************************************************
GLOBAL SYSTEM PARAMETER
NQ                 8
NT                 16
NM                 8
IREL               3
*******************************************************************************
SCF-INFO
INFO      NONE
SCFSTATUS START
FULLPOT   F
BREITINT  F
NONMAG    F
ORBPOL    NONE
EXTFIELD  F
BLCOUPL   F
BEXT          0.0000000000
SEMICORE  F
LLOYD     F
NE                30
IBZINT             2
NKTAB              0
XC-POT    PBE
SCF-ALG   BROYDEN2
SCF-ITER           0
SCF-MIX       0.1000000000
SCF-TOL       0.0000100000
RMSAVV    999999.0000000000
RMSAVB    999999.0000000000
EF            0.0000000000
VMTZ          0.0000000000
*******************************************************************************
LATTICE
SYSDIM       3D
SYSTYPE      BULK
BRAVAIS            5        orthorombic base-centered  mmm    D_2h
ALAT         `echo "scale=10;$a/1"|bc -l`
A(1)         0`echo "scale=10;${arr1[0,0]}/1"|bc -l`    0`echo "scale=10;${arr1[0,1]}/1"|bc -l`   `echo "scale=10;${arr1[0,2]}/1"|bc -l|awk '{printf "%.10f\n", $0}'`
A(2)        `echo "scale=10;${arr2[1,0]}/1"|bc -l|awk '{printf "%.10f\n", $0}'`    0`echo "scale=10;${arr2[1,1]}/1"|bc -l`   `echo "scale=10;${arr2[1,2]}/1"|bc -l|awk '{printf "%.10f\n", $0}'`
A(3)         `echo "scale=10;${arr3[2,0]}/1"|bc -l|awk '{printf "%.10f\n", $0}'`    `echo "scale=10;${arr3[2,1]}/1"|bc -l|awk '{printf "%.10f\n", $0}'`   0`echo "scale=10;${arr3[2,2]}/1"|bc -l`
*******************************************************************************
SITES
CARTESIAN T
BASSCALE      1.0000000000    1.0000000000    1.0000000000
        IQ      QX              QY              QZ
         1   -0.2500000000    1.0103629370    0`echo "scale=10;0.25*${ca}/1"|bc -l`
         2    0.2500000000    1.0103629370    0`echo "scale=10;0.25*${ca}/1"|bc -l`
         3   -0.2500000000    0.7216878280    0`echo "scale=10;0.75*${ca}/1"|bc -l`
         4    0.2500000000    0.7216878280    0`echo "scale=10;0.75*${ca}/1"|bc -l`
         5    0.0000000000    1.4433756560    0`echo "scale=10;0.25*${ca}/1"|bc -l`
         6    0.0000000000    0.2886751310    0`echo "scale=10;0.75*${ca}/1"|bc -l`
         7    0.0000000000    0.5773502620    0`echo "scale=10;0.25*${ca}/1"|bc -l`
         8    0.0000000000    1.1547005250    0`echo "scale=10;0.75*${ca}/1"|bc -l`
*******************************************************************************
OCCUPATION
        IQ     IREFQ       IMQ       NOQ  ITOQ  CONC
         1         1         1         2     1 1.000     2 0.000
         2         2         2         2     3 1.000     4 0.000
         3         3         3         2     5 1.000     6 0.000
         4         4         4         2     7 1.000     8 0.000
         5         5         5         2     9 0.000    10 1.000
         6         6         6         2    11 0.000    12 1.000
         7         7         7         2    13 1.000    14 0.000
         8         8         8         2    15 1.000    16 0.000
*******************************************************************************
REFERENCE SYSTEM
NREF              4
      IREF      VREF            RMTREF
         1    4.0000000000    0.0000000000
         2    4.0000000000    0.0000000000
         3    4.0000000000    0.0000000000
         4    4.0000000000    0.0000000000
         5    4.0000000000    0.0000000000
         6    4.0000000000    0.0000000000
         7    4.0000000000    0.0000000000
         8    4.0000000000    0.0000000000
*******************************************************************************
MAGNETISATION DIRECTION
KMROT              0
QMVEC         0.0000000000    0.0000000000    0.0000000000
        IQ      QMTET           QMPHI 
         1    0.0000000000    0.0000000000
         2    0.0000000000    0.0000000000
         3    0.0000000000    0.0000000000
         4    0.0000000000    0.0000000000
         5    0.0000000000    0.0000000000
         6    0.0000000000    0.0000000000
         7    0.0000000000    0.0000000000
         8    0.0000000000    0.0000000000
*******************************************************************************
MESH INFORMATION
MESH-TYPE EXPONENTIAL 
   IM      R(1)            DX         JRMT      RMT        JRWS      RWS
    1    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    2    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    3    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    4    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    5    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    6    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    7    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    8    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
*******************************************************************************
TYPES
   IT     TXTT        ZT     NCORT     NVALT    NSEMCORSHLT
    1     Fe_1            26        18         8              0
    2     Mn_1            25        18         7              0
    3     Fe_2            26        18         8              0
    4     Mn_2            25        18         7              0
    5     Fe_3            26        18         8              0
    6     Mn_3            25        18         7              0
    7     Fe_4            26        18         8              0
    8     Mn_4            25        18         7              0
    9     Fe_5            26        18         8              0
   10     Mn_5            25        18         7              0
   11     Fe_6            26        18         8              0
   12     Mn_6            25        18         7              0
   13     Ge_1            32        28         4              0
   14     Si_1            14        10         4              0
   15     Ge_2            32        28         4              0
   16     Si_2            14        10         4              0
!
cat >${ele_1}2${ele_2}${ele_3}_SCF.inp<<!
###############################################################################
#  SPR-KKR input file    ${ele_1}2{ele_2}${ele_3}_SCF.inp 
#  created by xband on Thu Dec 19 15:38:04 WET 2019
###############################################################################
 
CONTROL  DATASET     = ${ele_1}2${ele_2}${ele_3} 
         ADSI        = SCF 
         POTFIL      = ${ele_1}2${ele_2}${ele_3}.pot 
         PRINT = 0    
 
# MODE     SP-SREL 
 
# SITES    NL = { 4 }
 
TAU      BZINT= POINTS  NKTAB= 250 
 
ENERGY   GRID={5}  NE={30} 
         ImE=0.0 Ry   EMIN=-0.2 Ry
 
SCF      NITER=200 MIX=0.10 VXC=PBE
         TOL=0.000010  MIXOP=0.10  ISTBRY=1 
#         FULLPOT 
         QIONSCL=0.80 
         NOSSITER 

!
cat >${ele_1}2${ele_2}${ele_3}_JXC.inp<<!
###############################################################################
#  SPR-KKR input file    ${ele_1}2${ele_2}${ele_3}_JXC.inp 
#  created by xband on Thu Apr 23 11:50:55 WEST 2020
###############################################################################
 
CONTROL  DATASET     = ${ele_1}2${ele_2}${ele_3}
         ADSI        = JXC 
         POTFIL      = ${ele_1}2${ele_2}${ele_3}.pot 
         PRINT = 0    

# MODE     SP-SREL 
 
# SITES    NL = { 4 }
 
TAU      BZINT= POINTS  NKTAB= 250 
 
ENERGY   GRID={5}  NE={30} 
         EMIN=-0.2 Ry
 
TASK     JXC   CLURAD=4.0
!
cd ..
done
cd ..
done
