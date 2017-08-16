#! /bin/bash
#
#
export CUDA_VISIBLE_DEVICES="0"

for i in `cat step.list`
do
    k=`expr $i - 1`

    echo "Step:" $i

    mdin="pdt.in"
    prmtop="/home/german/pdz/top_files/lf.prmtop"

    if [ $i == 1 ]
    then

    	    mdout=${i/*/"$i"plf.out}
	    inpcrd="31elf.rst7"
	    restrt=${i/*/"$i"plf.rst7}
	    mdcrd=${i/*/"$i"plf.nc}

    	pmemd.cuda -O -i $mdin -o $mdout -p $prmtop -c $inpcrd -r $restrt -x $mdcrd 

        echo "Done step:" $i

        continue	
    fi

    mdout=${i/*/"$i"plf.out}
    inpcrd=${i/*/"$k"plf.rst7}
    restrt=${i/*/"$i"plf.rst7}
    mdcrd=${i/*/"$i"plf.nc}

    pmemd.cuda -O -i $mdin -o $mdout -p $prmtop -c $inpcrd -r $restrt -x $mdcrd 

    echo "Done step:" $i
done

exit 0
