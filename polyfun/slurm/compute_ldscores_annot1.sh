#!/bin/bash 

#SBATCH -p long
#SBATCH -o ldscores_%A.%a.out
#SBATCH -e ldscores_%A.%a.err

#SBATCH -c 8

echo "------------------------------------------------" 
echo "Run on host: "`hostname` 
echo "Operating system: "`uname -s` 
echo "Username: "`whoami` 
echo "Started at: "`date` 
echo "------------------------------------------------" 
 
date

## 1       2245570 SKI     1245570 3245570
#bash finemap_test.bash 1 1245570 3245570

sno=$SLURM_ARRAY_TASK_ID

bash compute_ldscores_annot1.bash $sno

date
