#!/bin/bash
for i in {1..9..1}
do
k=$(( 10 - $i ))

conc_2=`echo "0.1 * $i" | bc`
conc_1=`echo "0.1 * $k" | bc`

sed 's/conc_1/conc_1/g' Co2Mn0.9V0.1Ti.pot > Co2Mn0${conc_1}V0${conc_2}Ti.pot  
sed 's/conc_2/conc_2/g' Co2Mn0.9V0.1Ti.pot > Co2Mn0${conc_1}V0${conc_2}Ti.pot

mkdir `pwd`/Co2Mn0${conc_1}V0${conc_2}Ti
mv `pwd`/Co2Mn0${conc_1}V0${conc_2}Ti.pot `pwd`/Co2Mn0${conc_1}V0${conc_2}Ti
done
