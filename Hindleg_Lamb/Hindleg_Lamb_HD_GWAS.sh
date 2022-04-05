#!/bin/sh  
#$ -cwd  
#$ -l h_rt=3:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=200G  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes  
#$ -t 1-26  
#$ -tc 10  

. /etc/profile.d/modules.sh  

module load igmm/apps/dissect/1.15.2c  
module load igmm/apps/plink/1.90b4  

i=$SGE_TASK_ID  

plink --file ../../InputData/HD_QC --sheep --not-chr 0,${i},X --make-bed --out HD/NoChr${i}  

mpirun -np 8 dissect.mpich  --make-grm --bfile HD/NoChr${i} --out HD/NoChr${i}_GRM  

echo "HD/Chr${i} HD/NoChr${i}_GRM" > HD/GWAS_GRM${i}.txt  

plink --file ../../InputData/HD_QC --sheep --chr ${i} --make-bed --out HD/Chr${i}  

if [[ -f HD/NoChr${i}_GRM.badsnps ]]  
then  
plink --bfile HD/NoChr${i} --sheep --not-chr 0,${i},X  --exclude HD/NoChr${i}_GRM.badsnps  --make-bed --out HD/NoChr${i}_2  

mpirun -np 8 dissect.mpich  --make-grm --bfile HD/NoChr${i}_2 --out HD/NoChr${i}_GRM  

fi  

mpirun -np 8 dissect.mpich  --gwas --bfile-grm-list HD/GWAS_GRM${i}.txt --pheno LambHindLegPhenotypes.txt --pheno-col 1 --covar LambHindLegAssoc.txt --qcovar LambHindLegQAssoc.txt --random-effects LambHindLegRandom.txt --random-effects-cols 1 2 --reml-maxit 100 --out HD/LambHindLeg_HD_GWAS_Chr${i}  

if [[ -f HD/LambHindLeg_HD_GWAS_Chr${i}.badsnps ]]  
then  
plink --bfile HD/Chr${i} --sheep --chr ${i} --exclude HD/LambHindLeg_HD_GWAS_Chr${i}.badsnps --make-bed --out HD/Chr${i}_2  

echo "HD/Chr${i}_2 HD/NoChr${i}_GRM" > HD/GWAS_GRM${i}.txt  

mpirun -np 8 dissect.mpich  --gwas --bfile-grm-list HD/GWAS_GRM${i}.txt --pheno LambHindLegPhenotypes.txt --pheno-col 1 --covar LambHindLegAssoc.txt --qcovar LambHindLegQAssoc.txt --random-effects LambHindLegRandom.txt --random-effects-cols 1 2 --reml-maxit 100 --out HD/LambHindLeg_HD_GWAS_Chr${i}  

fi    



