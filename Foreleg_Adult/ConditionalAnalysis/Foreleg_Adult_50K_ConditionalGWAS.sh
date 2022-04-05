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
  
plink --bfile 50K/Conditional_50K_Geno --sheep --not-chr 0,${i},X --keep AdultForeLegPhenotypes.txt --make-bed --out 50K/Conditional_NoChr${i}  
  
dissect.mpich  --make-grm --bfile 50K/Conditional_NoChr${i} --out 50K/Conditional_NoChr${i}_GRM  
  
echo "50K/Conditional_Chr${i} 50K/Conditional_NoChr${i}_GRM" > 50K/Conditional_GWAS_GRM${i}.txt  
  
plink --bfile 50K/Conditional_50K_Geno --sheep --chr ${i} --keep AdultForeLegPhenotypes.txt --make-bed --out 50K/Conditional_Chr${i}  
  
if [[ -f 50K/Conditional_NoChr${i}_GRM.badsnps ]]  
then  
plink --bfile 50K/Conditional_NoChr${i} --sheep --exclude 50K/Conditional_NoChr${i}_GRM.badsnps  --make-bed --out 50K/Conditional_NoChr${i}_2  
  
dissect.mpich  --make-grm --bfile 50K/Conditional_NoChr${i}_2 --out 50K/Conditional_NoChr${i}_GRM
  
fi  
  
dissect.mpich  --gwas --reml-maxit 100 --bfile-grm-list 50K/Conditional_GWAS_GRM${i}.txt --pheno AdultForeLegPhenotypes.txt --pheno-col 2 --covar Assoc_50K.txt --qcovar QAssoc_50K.txt --random-effects AdultForeLegRandom.txt --random-effects-cols 1 2  --out 50K/AdultForeLeg_50K_GWAS_Conditional_Chr${i}  
  
if [[ -f 50K/AdultForeLeg_50K_GWAS_Conditional_Chr${i}.badsnps ]]  
then  
plink --bfile 50K/Chr${i} --sheep --exclude 50K/AdultForeLeg_50K_GWAS_Conditional_Chr${i}.badsnps --make-bed --out 50K/Conditional_Chr${i}_2  
  
echo "50K/Conditional_Chr${i}_2 50K/Conditional_NoChr${i}_GRM" > 50K/Conditional_GWAS_GRM${i}.txt  
  
dissect.mpich  --gwas --reml-maxit 100 --bfile-grm-list 50K/Conditional_GWAS_GRM${i}.txt --pheno AdultForeLegPhenotypes.txt --pheno-col 2 --covar Assoc_50K.txt --qcovar QAssoc_50K.txt --random-effects AdultForeLegRandom.txt --random-effects-cols 1 2 --out 50K/AdultForeLeg_50K_GWAS_Conditional_Chr${i}    
fi 

