#!/bin/bash
declare -A arr
# first vector
arr[0,0]=0.5
arr[0,1]=-0.5
arr[0,2]=0
#second vector
arr[1,0]=0.5
arr[1,1]=0.5
arr[1,2]=0
#third vector
arr[2,0]=0
arr[2,1]=0
arr[2,2]=$c
array=`echo "${arr[0,0]} ${arr[0,1]} ${arr[0,2]}"`

echo "$array"
