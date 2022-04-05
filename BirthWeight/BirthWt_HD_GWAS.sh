#!/bin/sh  
#$ -cwd  
#$ -l h_rt=2:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=200G  
#$ -t 1-26  
#$ -tc 10  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes 
. /etc/profile.d/modules.sh  

module load igmm/apps/dissect/1.15.2c  
module load igmm/apps/plink/1.90b4  
  
i=$SGE_TASK_ID  
  
plink --bfile ../InputData/HD_QC --sheep --not-chr ${i},X --keep BirthWtPhenotypes.txt --make-bed --out HD/NoChr${i}  
  
dissect.mpich --bfile HD/NoChr${i} --make-grm --out HD/NoChr${i}_GRM  
  
echo "HD/Chr${i} HD/NoChr${i}_GRM" > HD/GWAS_GRM${i}.txt  
  
plink --bfile ../InputData/HD_QC --sheep --chr ${i} --keep BirthWtPhenotypes.txt --make-bed --out HD/Chr${i}  
  
if [[ -f HD/NoChr${i}_GRM.badsnps ]]  
then  
plink --bfile HD/NoChr${i} --sheep --exclude HD/NoChr${i}_GRM.badsnps  --make-bed --out HD/NoChr${i}_2  
  
dissect.mpich  --make-grm --bfile HD/NoChr${i}_2 --out HD/NoChr${i}_GRM
  
fi  
  
dissect.mpich  --gwas --bfile-grm-list HD/GWAS_GRM${i}.txt --pheno BirthWtPhenotypes.txt --covar BirthWtAssoc.txt --qcovar BirthWtQAssoc.txt --random-effects BirthWtRandom.txt --random-effects-cols 1,2  --out HD/BirthWt_HD_GWAS_Chr${i}  
  
if [[ -f HD/BirthWt_HD_GWAS_Chr${i}.badsnps ]]  
then  
plink --bfile HD/Chr${i} --sheep --exclude HD/BirthWt_HD_GWAS_Chr${i}.badsnps --make-bed --out HD/Chr${i}_2  
  
echo "HD/Chr${i}_2 HD/NoChr${i}_GRM" > HD/GWAS_GRM${i}.txt  
  
dissect.mpich  --gwas --bfile-grm-list HD/GWAS_GRM${i}.txt --pheno BirthWtPhenotypes.txt --covar BirthWtAssoc.txt --qcovar BirthWtQAssoc.txt --random-effects BirthWtRandom.txt --random-effects-cols 1,2 --out HD/BirthWt_HD_GWAS_Chr${i}    
fi 

