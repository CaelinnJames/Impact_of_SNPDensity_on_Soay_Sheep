#!/bin/sh  
#$ -cwd  
#$ -l h_rt=0:30:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=50G


sort -k 3,3 AdultForeLegPhenotypes.txt > Pheno1HD.txt

awk '($2 >0)' ../../InputData/HD_QC.ped > Ped1HD.ped
sort -k 2,2 Ped1HD.ped > Ped2HD.ped
join -1 3 -2 2 Pheno1HD.txt Ped2HD.ped > Ped3HD.ped
cut -d ' ' -f 1,4,5 --complement Ped3HD.ped > AdultForeLegHD.ped

rm Ped*HD.ped
rm Pheno1HD.txt

