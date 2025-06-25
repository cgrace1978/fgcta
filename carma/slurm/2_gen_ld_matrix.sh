#!/bin/bash 
 
#SBATCH -p short
#SBATCH -o gen_ld_%A.%a.out
#SBATCH -e gen_ld_%A.%a.err

echo "------------------------------------------------" 
echo "Run on host: "`hostname` 
echo "Operating system: "`uname -s` 
echo "Username: "`whoami` 
echo "Started at: "`date` 
echo "------------------------------------------------" 
 
date

FIRST=$SLURM_ARRAY_TASK_ID

LAST=$(($FIRST + $SLURM_ARRAY_TASK_STEP - 1))

for (( MY_TASK=$FIRST; MY_TASK<=$LAST; MY_TASK++ )) 
do
    chr=`grep -w ^$MY_TASK carma_loci.txt | cut -f 2`

#    bash gen_ld_matrix.bash $chr queries/loci_${MY_TASK}.txt1 ld_test/loci_${MY_TASK}
    bash gen_ld_matrix.bash $chr files_wannot/loci_${MY_TASK}.txt files_wannot/loci_${MY_TASK}_ld
done
date
