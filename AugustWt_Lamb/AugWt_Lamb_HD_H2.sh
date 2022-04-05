#!/bin/sh  
#$ -cwd  
#$ -l h_rt=2:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=150G  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes 
. /etc/profile.d/modules.sh  

module load igmm/apps/dissect/1.15.2c
module load igmm/apps/plink/1.90b4  

plink --file ../../InputData/HD_QC --sheep --not-chr 0,X --make-bed --out HD/LambWeightHD

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/LambWeightHD --pheno LambWeightPhenotypes.txt --pheno-col 1 --covar LambWeightAssoc.txt --qcovar LambWeightQAssoc.txt --random-effects LambWeightRandom.txt --random-effects-cols 1 2 --out HD/LambWt_HD_H2


if [[ -f HD/LambWt_HD_H2.badsnps ]]  
then  
plink --bfile HD/LambWeightHD --sheep  --exclude HD/LambWt_HD_H2.badsnps  --make-bed --out HD/LambWeightHDR  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/LambWeightHDR --pheno LambWeightPhenotypes.txt  --pheno-col 1 --covar LambWeightAssoc.txt --qcovar LambWeightQAssoc.txt --random-effects LambWeightRandom.txt --random-effects-cols 1 2 --out HD/LambWt_HD_H2

fi  




