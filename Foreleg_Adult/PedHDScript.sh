#!/bin/sh  
#$ -cwd  
#$ -l h_rt=0:30:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=50G


sort -k 3,3 AdultForeLegPhenotypes.txt > Pheno150K.txt

awk '($2 >0)' ../../InputData/Plates_1to87_QC3.ped > Ped150K.ped
sort -k 2,2 Ped150K.ped > Ped250K.ped
join -1 3 -2 2 Pheno150K.txt Ped250K.ped > Ped350K.ped
cut -d ' ' -f 1,4,5 --complement Ped350K.ped > AdultForeLeg50K.ped

rm Ped*50K.ped
rm Pheno150K.txt

