#!/bin/bash
#PBS -N temp_corta_total
#PBS -o temp_corta_total.out
#PBS -e temp_cort_total.err
#PBS -j oe
#PBS -l nodes=isengard:ppn=1
#PBS -l walltime=10:00:00

# Running AMBER
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/amber16/lib:/usr/local/cuda-8.0/lib64:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64:/opt/intel/composer_xe_2013.3.163/mpirt/lib/intel64:/opt/intel/composer_xe_2013.3.163/ipp/../compiler/lib/intel64:/opt/intel/composer_xe_2013.3.163/ipp/lib/intel64:/opt/intel/mic/coi/host-linux-release/lib:/opt/intel/mic/myo/lib:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64:/opt/intel/composer_xe_2013.3.163/mkl/lib/intel64:/opt/intel/composer_xe_2013.3.163/tbb/lib/intel64/gcc4.4:/usr/local/cuda-8.0/lib64:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64
export AMBERHOME=/apps/amber16
export MDEXE=$AMBERHOME/bin/pmemd.cuda

cd $PBS_O_WORKDIR

for ((i=1;i<401;i++))
do

	archivo="$i"corta_temp_cpp_in
	salida="$i"salida
	
	echo "parm /scratch/pbarletta/pdz/top_files/lb.prmtop" >> $archivo
	echo "trajin /scratch/pbarletta/pdz/run/lb/neq/data/corta_3/T"$i"plb_3.nc" >> $archivo
	echo "temperature T1 :1-124 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/nolig_total/corta/"$i"corta_temp_total" >> $archivo
	echo "go" >> $archivo
	
	$AMBERHOME/bin/cpptraj < $archivo > $salida
	rm $archivo $salida

done

exit 0
