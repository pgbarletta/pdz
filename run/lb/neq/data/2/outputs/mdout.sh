#!/bin/bash

# Extract heat and equil mdout info

for ((i=11; i<12; i++))
do
    perl process_mdout.perl "$i"plb_2.out
    
    mv summary.ETOT "$i"etot.dat
    mv summary.EPTOT "$i"eptot.dat
    mv summary.EKTOT "$i"ektot.dat
    mv summary.TEMP "$i"temp.dat
    mv summary.PRES "$i"pres.dat
    mv summary.VOLUME "$i"vol.dat
    mv summary.DENSITY "$i"density.dat
    rm summary*
done 
