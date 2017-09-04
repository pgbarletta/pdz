#!/bin/bash

# Extract heat and equil mdout info
perl process_mdout.perl 1equ.out 2equ.out 3equ.out 4equ.out 5equ.out 6equ.out 7equ.out 8equ.out 9equ.out 10equ.out 11equ.out 12equ.out 13equ.out 14equ.out 15equ.out 16equ.out 17equ.out 18equ.out 19equ.out 20equ.out 21equ.out 22equ.out 23equ.out 24equ.out 25equ.out 26equ.out 27equ.out 28equ.out 29equ.out 30equ.out 

mv summary.ETOT etot.dat
mv summary.EPTOT eptot.dat
mv summary.EKTOT ektot.dat
mv summary.TEMP temp.dat
mv summary.PRES pres.dat
mv summary.VOLUME vol.dat
mv summary.DENSITY density.dat

rm summary*

