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

plink --file ../../InputData/Plates_1to87_QC3 --sheep --not-chr 0,X --make-bed --out 50K/LambForeLeg50K

mpirun -np 8 dissect.mpich  --reml --blue --bfile 50K/LambForeLeg50K --pheno LambForeLegPhenotypes.txt --pheno-col 1 --covar LambForeLegAssoc.txt --qcovar LambForeLegQAssoc.txt --random-effects LambForeLegRandom.txt --random-effects-cols 1 2 --out 50K/LambForeLeg_50K_H2


if [[ -f 50K/LambForeLeg_50K_H2.badsnps ]]  
then  
plink --bfile 50K/LambForeLeg50K --sheep  --exclude 50K/LambForeLeg_50K_H2.badsnps  --make-bed --out 50K/LambForeLeg50KR  

mpirun -np 8 dissect.mpich  --reml --blue --bfile 50K/LambForeLeg50KR --pheno LambForeLegPhenotypes.txt  --pheno-col 1 --covar LambForeLegAssoc.txt --qcovar LambForeLegQAssoc.txt --random-effects LambForeLegRandom.txt --random-effects-cols 1 2 --out 50K/LambForeLeg_50K_H2

fi  
