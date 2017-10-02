#!/bin/bash
#PBS -N temp_larga 
#PBS -o temp_larga.out
#PBS -e temp_cort.err
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

	archivo="$i"larga_temp_cpp_in
        salida="$i"salida
	
	echo "parm /scratch/pbarletta/pdz/top_files/lb.prmtop" >> $archivo
	echo "trajin /scratch/pbarletta/pdz/run/lb/neq/data/larga_4/T"$i"plb_4.nc" >> $archivo
	echo "temperature T1 :12-19 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/1sse/"$i"larga_temp_1sse" >> $archivo
	echo "temperature T2 :20-34 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/2sse/"$i"larga_temp_2sse" >> $archivo
	echo "temperature T3 :25-29 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/3sse/"$i"larga_temp_3sse" >> $archivo
	echo "temperature T4 :30-32 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/4sse/"$i"larga_temp_4sse" >> $archivo
	echo "temperature T5 :33-35 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/5sse/"$i"larga_temp_5sse" >> $archivo
	echo "temperature T6 :36-54 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/6sse/"$i"larga_temp_6sse" >> $archivo
	echo "temperature T7 :55-58 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/7sse/"$i"larga_temp_7sse" >> $archivo
	echo "temperature T8 :59-64 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/8sse/"$i"larga_temp_8sse" >> $archivo
	echo "temperature T9 :65-70 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/9sse/"$i"larga_temp_9sse" >> $archivo
	echo "temperature T10 :71-74 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/10sse/"$i"larga_temp10_sse" >> $archivo
	echo "temperature T11 :75-81 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/11sse/"$i"larga_temp_11sse" >> $archivo
	echo "temperature T12 :82-85 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/12sse/"$i"larga_temp_12sse" >> $archivo
	echo "temperature T13 :86-89 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/13sse/"$i"larga_temp_13sse" >> $archivo
	echo "temperature T14 :90-98 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/14sse/"$i"larga_temp_14sse" >> $archivo
	echo "temperature T15 :99-104 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/15sse/"$i"larga_temp_15sse" >> $archivo
	echo "temperature T16 :105-112 ntc 1 out /scratch/pbarletta/pdz/run/lb/neq/temperatura/16sse/"$i"larga_temp_16sse" >> $archivo
	echo "go" >> $archivo

        $AMBERHOME/bin/cpptraj < $archivo > $salida
        rm $archivo $salida

done

exit 0
