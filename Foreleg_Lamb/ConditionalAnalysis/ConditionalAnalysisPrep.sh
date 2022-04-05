#!/bin/sh  
#$ -cwd  
#$ -l h_rt=1:00:00  
#$ -pe sharedmem 1  
#$ -l h_vmem=100G  
#$ -M s1944058@sms.ed.ac.uk  
#$ -m baes   


. /etc/profile.d/modules.sh  

module load igmm/apps/plink/1.90b4 
module load igmm/apps/R/3.5.1

R < GetSNPs.R --save

plink --bfile 50K/LambForeLeg50K --sheep --not-chr 0,X --exclude SNPs_50K.txt --make-bed --out 50K/Conditional_50K_Geno  
plink --bfile HD/LambForeLegHD --sheep --not-chr X --exclude SNPs_HD.txt --make-bed --out HD/Conditional_HD_Geno  

plink --bfile 50K/LambForeLeg50K --sheep --extract SNPs_50K.txt --keep LambForeLegPhenotypes.txt --recodeA --out LambHLSNP 
cut -d ' ' -f 3-6 --complement LambHLSNP.raw > LambHLSNP.txt
sed '1d' LambHLSNP.txt > LambHLSNP2.txt 

sort -k 2,2 LambForeLegQAssoc.txt > Assoc1.txt  
sort -k 2,2 LambHLSNP2.txt > Assoc2.txt  

R <  ConditionalAnalysisPrep.R --save

sort -k 2,2 LambForeLegAssoc.txt > Assoc_50K.txt  
sort -k 2,2 Assoc3.txt > QAssoc_50K.txt 

rm LambHLSNP*
rm Assoc2.txt
rm Assoc1.txt
rm Assoc3.txt

plink --bfile HD/LambForeLegHD --sheep --extract SNPs_HD.txt --keep LambForeLegPhenotypes.txt --recodeA --out LambHLSNP
cut -d ' ' -f 3-6 --complement LambHLSNP.raw > LambHLSNP.txt
sed '1d' LambHLSNP.txt > LambHLSNP2.txt

sort -k 2,2 LambForeLegQAssoc.txt > Assoc1.txt
sort -k 2,2 LambHLSNP2.txt > Assoc2.txt

R <  ConditionalAnalysisPrep.R --save

sort -k 2,2 LambForeLegAssoc.txt > Assoc_HD.txt
sort -k 2,2 Assoc3.txt > QAssoc_HD.txt

rm LambHLSNP*
rm Assoc2.txt
rm Assoc1.txt
rm Assoc3.txt



