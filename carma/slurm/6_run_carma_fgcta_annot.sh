#!/bin/bash 

#SBATCH -p short
#SBATCH --mem-per-cpu 42000
#SBATCH -c 3
#SBATCH -o carma_annot_%A.%a.out
#SBATCH -e carma_annot_%A.%a.err
 
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
    Rscript run_carma_fgcta_annot1.R $MY_TASK
done

date
