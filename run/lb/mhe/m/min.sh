#! /bin/bash

# Running AMBER
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64
export AMBERHOME=/apps/amber16
export MDEXE=$AMBERHOME/bin/pmemd.cuda

mdin="min.in"
mdout="min.out"
prmtop="/scratch/pbarletta/pdz/top_files/lb.prmtop"
inpcrd="lb.rst7"
restrt="mlb.rst7"
refc="lb.rst7"

$AMBERHOME/bin/pmemd -O -i $mdin -o $mdout -p $prmtop -c $inpcrd -r $restrt -ref $refc
 
exit 0
