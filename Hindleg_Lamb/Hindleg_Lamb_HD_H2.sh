#!/bin/sh  
#$ -cwd  
#$ -l h_rt=3:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=250G  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes 
. /etc/profile.d/modules.sh  

module load igmm/apps/dissect/1.15.2c
module load igmm/apps/plink/1.90b4  

plink --file ../../InputData/HD_QC --sheep --not-chr 0,X --make-bed --out HD/LambHindLegHD

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/LambHindLegHD --pheno LambHindLegPhenotypes.txt --pheno-col 1 --covar LambHindLegAssoc.txt --qcovar LambHindLegQAssoc.txt --random-effects LambHindLegRandom.txt --random-effects-cols 1 2 --reml-maxit 100 --out HD/LambHindLeg_HD_H2


if [[ -f HD/LambHindLeg_HD_H2.badsnps ]]  
then  
plink --bfile HD/LambHindLegHD --sheep  --exclude HD/LambHindLeg_HD_H2.badsnps  --make-bed --out HD/LambHindLegHDR  

mpirun -np 8 dissect.mpich  --reml --blue --bfile HD/LambHindLegHDR --pheno LambHindLegPhenotypes.txt  --pheno-col 1 --covar LambHindLegAssoc.txt --qcovar LambHindLegQAssoc.txt --random-effects LambHindLegRandom.txt --random-effects-cols 1 2 --reml-maxit 100 --out HD/LambHindLeg_HD_H2

fi  

