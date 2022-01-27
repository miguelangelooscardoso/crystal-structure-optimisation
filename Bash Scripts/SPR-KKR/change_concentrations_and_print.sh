#!/bin/bash

SPRPATH=/home/mcardoso

ele_1=Mn
ele_2=V

for i in {1..9..1}
do
k=$(( 10 - $i ))

conc_2=`echo "0.1 * $i" | bc`
conc_1=`echo "0.1 * $k" | bc`

cat >Co2Mn0.9V0.1Ti.pot<<!
*******************************************************************************
HEADER    'SCF-start data created by xband  Thu Dec 19 15:38:04 WET 2019'
*******************************************************************************
TITLE     'SPR-KKR calculation for Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti'
SYSTEM    Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti
PACKAGE   SPRKKR
FORMAT    6  (21.05.2007)
*******************************************************************************
GLOBAL SYSTEM PARAMETER
NQ                 4
NT                 5
NM                 4
IREL               2
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
ALAT         11.0359997733
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
         3         3         3         2     3 0$conc_1     4 0$conc_2
         4         4         4         1     5 1.000
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
    1    0.0000010000    0.0205031231    0    2.1906956035  721    2.5772889452
    2    0.0000010000    0.0205031231    0    2.1906956035  721    2.5772889452
    3    0.0000010000    0.0205502066    0    2.2662336926  721    2.6661572854
    4    0.0000010000    0.0207145692    0    2.5509358954  721    3.0011010534
*******************************************************************************
TYPES
   IT     TXTT        ZT     NCORT     NVALT    NSEMCORSHLT
    1     Co_1            27        18         9              0
    2     Co_2            27        18         9              0
    3     Mn              25        18         7              0
    4     V               23        18         5              0
    5     Ti              22        18         4              0
!


mkdir `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti
cp `pwd`/Co2Mn0.9V0.1Ti.pot `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti
mv `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti/Co2Mn0.9V0.1Ti.pot `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti.pot
cat >Co2Mn0.9V0.1Ti_SCF.inp<<!
###############################################################################
#  SPR-KKR input file    Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti_SCF.inp 
#  created by xband on Thu Dec 19 15:38:04 WET 2019
###############################################################################
 
CONTROL  DATASET     = Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti 
         ADSI        = SCF 
         POTFIL      = Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti.pot 
         PRINT = 0    
 
MODE     SP-SREL 
 
SITES    NL = { 4 }
 
TAU      BZINT= POINTS  NKTAB= 250 
 
ENERGY   GRID={5}  NE={30} 
         ImE=0.0 Ry   EMIN=-0.2 Ry
 
SCF      NITER=200 MIX=0.20 VXC=PBE
         TOL=0.000010  MIXOP=0.20  ISTBRY=1 
         FULLPOT 
         QIONSCL=0.80 
         NOSSITER 
!
cp `pwd`/Co2Mn0.9V0.1Ti_SCF.inp `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti
mv `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti/Co2Mn0.9V0.1Ti_SCF.inp `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti_SCF.inp
cd `pwd`/Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti
taskset --cpu-list 1,2 ${SPRPATH}/kkrscf7.7 <Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti_SCF.inp &> Co2${ele_1}0${conc_1}${ele_2}0${conc_2}Ti_SCF.out &
cd ..
done
