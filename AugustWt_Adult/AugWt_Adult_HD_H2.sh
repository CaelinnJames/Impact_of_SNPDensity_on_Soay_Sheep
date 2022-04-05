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

plink --file ../../InputData/HD_QC --ped AdultWeightHD.ped --sheep --not-chr 0,X --make-bed --out HD/AdultWeightHD

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultWeightHD --pheno AdultWeightPhenotypes.txt --pheno-col 2 --covar AdultWeightAssoc.txt --qcovar AdultWeightQAssoc.txt --random-effects AdultWeightRandom.txt --random-effects-cols 1 2 --out HD/AdultWt_HD_H2


if [[ -f HD/AdultWt_HD_H2.badsnps ]]  
then  
plink --bfile HD/AdultWeightHD --sheep  --exclude HD/AdultWt_HD_H2.badsnps  --make-bed --out HD/AdultWeightHDR  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultWeightHDR --pheno AdultWeightPhenotypes.txt  --pheno-col 2 --covar AdultWeightAssoc.txt --qcovar AdultWeightQAssoc.txt --random-effects AdultWeightRandom.txt --random-effects-cols 1 2 --out HD/AdultWt_HD_H2

fi  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultWeightHD --pheno AdultWeightPhenotypes.txt --pheno-col 2  --random-effects AdultWeightRandom.txt --random-effects-cols 1 2 --out HD/AdultWt_HD_TotalPhenotypeVariance


if [[ -f HD/AdultWt_HD_TotalPhenotypeVariance.badsnps ]]  
then  
plink --bfile HD/AdultWeightHD --sheep  --exclude HD/AdultWt_HD_TotalPhenotypeVariance.badsnps  --make-bed --out HD/AdultWeightHDR  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultWeightHDR --pheno AdultWeightPhenotypes.txt  --pheno-col 2  --random-effects AdultWeightRandom.txt --random-effects-cols 1 2 --out HD/AdultWt_HD_TotalPhenotypeVariance

fi  


