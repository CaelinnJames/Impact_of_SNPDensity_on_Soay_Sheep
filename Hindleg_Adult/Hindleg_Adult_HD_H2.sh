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

plink --file ../../InputData/HD_QC --ped AdultHindLegHD.ped --sheep --not-chr 0,X --make-bed --out HD/AdultHindLegHD

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultHindLegHD --pheno AdultHindLegPhenotypes.txt --pheno-col 2 --covar AdultHindLegAssoc.txt --qcovar AdultHindLegQAssoc.txt --random-effects AdultHindLegRandom.txt --random-effects-cols 1 2 --out HD/AdultHindLeg_HD_H2


if [[ -f HD/AdultHindLeg_HD_H2.badsnps ]]  
then  
plink --bfile HD/AdultHindLegHD --sheep  --exclude HD/AdultHindLeg_HD_H2.badsnps  --make-bed --out HD/AdultHindLegHDR  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultHindLegHDR --pheno AdultHindLegPhenotypes.txt  --pheno-col 2 --covar AdultHindLegAssoc.txt --qcovar AdultHindLegQAssoc.txt --random-effects AdultHindLegRandom.txt --random-effects-cols 1 2 --out HD/AdultHindLeg_HD_H2

fi  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultHindLegHD --pheno AdultHindLegPhenotypes.txt --pheno-col 2  --random-effects AdultHindLegRandom.txt --random-effects-cols 1 2 --out HD/AdultHindLeg_HD_TotalPhenotypeVariance


if [[ -f HD/AdultHindLeg_HD_TotalPhenotypeVariance.badsnps ]]  
then  
plink --bfile HD/AdultHindLegHD --sheep  --exclude HD/AdultHindLeg_HD_TotalPhenotypeVariance.badsnps  --make-bed --out HD/AdultHindLegHDR  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/AdultHindLegHDR --pheno AdultHindLegPhenotypes.txt  --pheno-col 2  --random-effects AdultHindLegRandom.txt --random-effects-cols 1 2 --out HD/AdultHindLeg_HD_TotalPhenotypeVariance

fi  


