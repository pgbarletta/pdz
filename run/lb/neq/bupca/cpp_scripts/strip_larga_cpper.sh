#!/bin/bash
#PBS -N strip_PCA_larga
#PBS -o strip_PCA_larga.out
#PBS -e strip_PCA_larga 
#PBS -j oe
#PBS -l nodes=isengard:ppn=1
#PBS -l walltime=10:00:00

########### Specify the input and output file names #############
# Running AMBER
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/amber16/lib:/usr/local/cuda-8.0/lib64:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64:/opt/intel/composer_xe_2013.3.163/mpirt/lib/intel64:/opt/intel/composer_xe_2013.3.163/ipp/../compiler/lib/intel64:/opt/intel/composer_xe_2013.3.163/ipp/lib/intel64:/opt/intel/mic/coi/host-linux-release/lib:/opt/intel/mic/myo/lib:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64:/opt/intel/composer_xe_2013.3.163/mkl/lib/intel64:/opt/intel/composer_xe_2013.3.163/tbb/lib/intel64/gcc4.4:/usr/local/cuda-8.0/lib64:/opt/intel/composer_xe_2013.3.163/compiler/lib/intel64
export AMBERHOME=/apps/amber16
export MDEXE=$AMBERHOME/bin/pmemd.cuda
cd $PBS_O_WORKDIR

for ((i=1; i<181; i++))
do
    archivo="$i"pca_neq_larga_cpp_in
    echo parm /scratch/pbarletta/pdz/top_files/lb.prmtop > $archivo
    
    for ((j=1; j<401; j++))
    do
    	echo trajin /scratch/pbarletta/pdz/run/lb/neq/data/larga_4/T"$j"plb_4.nc "$i" "$i" 1 >> $archivo
    done
    echo autoimage familiar >> $archivo
    echo strip :WAT >> $archivo
    echo strip :Cl- >> $archivo
    echo strip :Na+ >> $archivo
    echo rms first :12-112@CA RMSD >> $archivo
    echo trajout /scratch/pbarletta/pdz/run/lb/neq/pca/larga/step_"$i"plb_4.nc >> $archivo
    echo go >> $archivo
    
    /apps/amber16/bin/cpptraj < $archivo > PCA_larga.out
    rm $archivo
done
