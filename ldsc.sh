##LDSR wiki https://github.com/bulik/ldsc

source activate ldsc
## Reformating Summary Statistics for ADHD
munge_sumstats.py \
 --out adhd \
 --merge-alleles /data2/home/crcyj/ldsc/w_hm3.snplist \
 --chunksize 500000 \
 --sumstats adhd.sumstats \
 --N-cas-col NCAS \
 --N-con-col NCON
## Reformating Summary Statistics for testosterone traits
munge_sumstats.py \
 --out testosterone \
 --merge-alleles /data2/home/crcyj/ldsc/w_hm3.snplist \
 --chunksize 500000 \
 --sumstats testosterone.sumstats
##LD Score Regression
ldsc.py \
--rg testosterone.sumstats.gz,adhd.sumstats.gz  --ref-ld-chr ~/ldsc/eur_w_ld_chr/ --w-ld-chr ~/ldsc/eur_w_ld_chr/ --out testosterone_adhd