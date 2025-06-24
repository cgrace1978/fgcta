#!/bin/bash

cd files_wannot

for i in {1..215};
do
#    sed '1d' $i | cut -f 1 > 
    echo $i
    sed '1d' loci_${i}.wa.summstat.txt | cut -f 1 > loci_${i}.txt
#    break
done
