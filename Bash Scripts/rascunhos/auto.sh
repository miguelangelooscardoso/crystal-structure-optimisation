#! /bin/bash

[ -z "`echo $vasp_std`" ] && vasp_std="mpirun -np 8 /home/mcardoso/vasp_std_mpi"

for i in 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do

cd `pwd`/$i

$vasp_std

E=`awk '/F=/ {print $0}' OSZICAR` ; echo $i $j  $E  >>SUMMARY

cd ..

done
