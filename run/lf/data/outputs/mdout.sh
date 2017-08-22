#!/bin/bash

# Extract heat and equil mdout info
perl process_mdout.perl plf.out 


mv summary.ETOT etot.dat
mv summary.EPTOT eptot.dat
mv summary.EKTOT ektot.dat
mv summary.TEMP temp.dat
mv summary.PRES pres.dat
mv summary.VOLUME vol.dat
mv summary.DENSITY density.dat

rm summary*

