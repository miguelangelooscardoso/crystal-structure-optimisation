#!/bin/bash
# Create .pot SCF.inp and JXC.inp L21 Fe2MnGe
SPRPATH=/home/mcardoso

function crossProduct {
    local -n v1=$1
    local -n v2=$2
    local result=()

    # You should remain to use bc because Bash only does integers. 
    result+=($( echo "(${v1[1]} * ${v2[2]}) - (${v1[2]} * ${v2[1]}) " | bc -l))
    result+=($( echo "-((${v1[0]} * ${v2[2]}) - (${v1[2]} * ${v2[0]}))" | bc -l))
    result+=($( echo "(${v1[0]} * ${v2[1]}) - (${v1[1]} * ${v2[0]})" | bc -l))
    echo "${result[@]}"
}

# elements
ele_1=Fe
ele_2=Mn
ele_3=Ge
ele_4=Si

# concentrations
c_3=`echo "scale=3;0.00243/1"|bc -l`
c_4=`echo "scale=3;(1-${c_3})/1"|bc -l`
# exchange coupling functional
XC=PBE
mkdir ${XC}
cd ${XC}
mkdir ${ele_1}2${ele_2}${ele_3}0${c_3}${ele_4}0${c_4}
cd ${ele_1}2${ele_2}${ele_3}0${c_3}${ele_4}0${c_4}

# Optimized Lattice Parameters (angstrom [Å])
a_exp=`echo "5.67077"|bc -l`
echo $a_exp
b_exp=`echo "${a_exp}"|bc -l`
echo $b_exp
c_exp=`echo "${a_exp}"|bc -l`
echo $c_exp

# Experimental Lattice Parameters (atomic units of length [a.u.])
a_exp=`echo "1.8897259885789*${a_exp}"|bc -l`
echo $a_exp
b_exp=`echo "1.8897259885789*${b_exp}"|bc -l`
echo $b_exp
c_exp=`echo "1.8897259885789*${c_exp}"|bc -l`
echo $c_exp

# V_exp 
v_exp=`echo "((${a_exp})^3)"|bc -l` 
echo $v_exp

# Experimental Lattice ratios
ba_exp=$(echo "${b_exp}/${a_exp}"|bc -l)
echo $ba_exp
ca_exp=$(echo "${c_exp}/${a_exp}"|bc -l)
echo $ca_exp

declare -A arr
# first vector
arr1[0,0]=0
arr1[0,1]=0.5
arr1[0,2]=0.5
#second vector
arr2[1,0]=0.5
arr2[1,1]=0
arr2[1,2]=0.5
#third vector
arr3[2,0]=0.5
arr3[2,1]=0.5
arr3[2,2]=0
echo "${arr1[0,0]} ${arr1[0,1]} ${arr1[0,2]}"  # example

vectResult=($(crossProduct arr2 arr3))
echo ${vectResult[0]} ${vectResult[1]} ${vectResult[2]}

dotProduct=$(echo "${arr1[0,0]}*${vectResult[0]}+${arr1[0,1]}*${vectResult[1]}+${arr1[0,2]}*${vectResult[2]}"|bc -l)
echo $dotProduct

pi=`echo "scale=10; 4*a(1)" | bc -l`

echo $pi

rws=`echo "e((1/3)*l((${dotProduct}*${a_exp}^3)*(3/(4*4*${pi}))))"|bc -l` #NQ=4

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
NQ                 4
NT                 5
NM                 4
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
XC-POT    ${XC}
SCF-ALG   BROYDEN2
SCF-ITER           0
SCF-MIX       0.2000000000
SCF-TOL       0.0000100000
RMSAVV    999999.0000000000
RMSAVB    999999.0000000000
EF            0.0000000000
VMTZ          0.0000000000
*******************************************************************************
LATTICE
SYSDIM       3D
SYSTYPE      BULK
BRAVAIS           13        cubic       face-centered  m3m    O_h 
ALAT          `echo "scale=10;${a_exp}/1"|bc -l`
A(1)          0.0000000000    0.5000000000    0.5000000000
A(2)          0.5000000000   -0.0000000000    0.5000000000
A(3)          0.5000000000    0.5000000000    0.0000000000
*******************************************************************************
SITES
CARTESIAN T
BASSCALE      1.0000000000    1.0000000000    1.0000000000
        IQ      QX              QY              QZ
         1    0.2500000000    0.2500000000    0.2500000000
         2    0.7500000000    0.7500000000    0.7500000000
         3    0.0000000000    0.0000000000    0.0000000000
         4    0.5000000000    0.5000000000    0.5000000000
*******************************************************************************
OCCUPATION
        IQ     IREFQ       IMQ       NOQ  ITOQ  CONC
         1         1         1         1     1 1.000
         2         2         2         1     2 1.000
         3         3         3         1     3 1.000
         4         4         4         2     4 0${c_3}     5 0${c_4}
*******************************************************************************
REFERENCE SYSTEM
NREF              4
      IREF      VREF            RMTREF
         1    4.0000000000    0.0000000000
         2    4.0000000000    0.0000000000
         3    4.0000000000    0.0000000000
         4    4.0000000000    0.0000000000
*******************************************************************************
MAGNETISATION DIRECTION
KMROT              0
QMVEC         0.0000000000    0.0000000000    0.0000000000
        IQ      QMTET           QMPHI 
         1    0.0000000000    0.0000000000
         2    0.0000000000    0.0000000000
         3    0.0000000000    0.0000000000
         4    0.0000000000    0.0000000000
*******************************************************************************
MESH INFORMATION
MESH-TYPE EXPONENTIAL 
   IM      R(1)            DX         JRMT      RMT        JRWS      RWS
    1    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    2    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    3    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
    4    0.0000010000    0`echo "scale=10;$dx/1"|bc -l`    0    `echo "scale=10;$rmt/1"|bc -l`  721    `echo "scale=10;$rws"/1|bc -l`
*******************************************************************************
TYPES
   IT     TXTT        ZT     NCORT     NVALT    NSEMCORSHLT
    1     Fe_1            26        18         8              0
    2     Fe_2            26        18         8              0
    3     Mn              25        18         7              0
    4     Ge              32        28         4              0
    5     Si              14        10         4              0
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
 
SCF      NITER=200 MIX=0.20 VXC=${XC}
         TOL=0.000010  MIXOP=0.20  ISTBRY=1 
#         FULLPOT 
         QIONSCL=1.00
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
~/kkrscf7.7 <Fe2MnGe_SCF.inp &> Fe2MnGe_SCF.out &
cd ..
cd ..
