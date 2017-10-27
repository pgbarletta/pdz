#!/bin/bash
#PBS -N 2PCA_larga
#PBS -o 2PCA_larga.out
#PBS -e 2PCA_larga 
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
	echo parm /scratch/pbarletta/pdz/top_files/dry_lb.prmtop > $archivo
        echo trajin /scratch/pbarletta/pdz/run/lb/neq/pca/larga/step_"$i"plb_4.nc >> $archivo
        echo  >> $archivo
        echo # Step two. RMS-Fit to average structure. Calculate covariance matrix. >> $archivo
        echo reference /scratch/pbarletta/pdz/run/lb/neq/pca/t0/avg_t0_lb.pdb [avg] >> $archivo
	echo rms ref [avg] :12-112@CA RMSD >> $archivo
	echo matrix mwcovar name mtx_lb :12-112@CA >> $archivo
	echo createcrd crd_lb >> $archivo
	echo run >> $archivo
	echo  >> $archivo
	echo # Step three. Diagonalize matrix. >> $archivo
	echo runanalysis diagmatrix mtx_lb vecs 297 out /scratch/pbarletta/pdz/run/lb/neq/2pca/larga/"$i"modes_larga >> $archivo
	echo go >> $archivo

	/apps/amber16/bin/cpptraj < $archivo > PCA_larga.out
	rm $archivo
done
