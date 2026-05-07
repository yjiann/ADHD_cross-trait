##mixer wiki https:// github.com/precimed/mixer

## Reformating Summary Statistics
python ~/mixer/python_convert/sumstats.py csv --sumstats adhd.sumstats --out adhd.csv  --force --auto --head 5;
python ~/biosoft/mixer/python_convert/sumstats.py zscore --sumstats adhd.csv | \
python ~/biosoft/mixer/python_convert/sumstats.py qc --exclude-ranges 6:26000000-34000000 | \
python ~/biosoft/mixer/python_convert/sumstats.py neff --drop --factor 4 --out adhd_qc_noMHC.csv --force;

python ~/mixer/python_convert/sumstats.py csv --sumstats testosterone.sumstats --out testosterone.csv  --force --auto --head 5;
python ~/biosoft/mixer/python_convert/sumstats.py zscore --sumstats testosterone.csv | \
python ~/biosoft/mixer/python_convert/sumstats.py qc --exclude-ranges 6:26000000-34000000 | \
python ~/biosoft/mixer/python_convert/sumstats.py neff --drop --factor 4 --out testosterone_qc_noMHC.csv --force;

export MIXER_SIF=/data2/home/crcyj/biosoft/mixer/mixer.sif
export MIXER_PY="singularity exec --home /data2/home/crcyj/mixer:/home ${MIXER_SIF} python /tools/mixer/precimed/mixer.py"
export MIXER_COMMON_ARGS=" --ld-file ./1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --bim-file ./1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --extract ./1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep1.snps"

${MIXER_PY} fit1 $MIXER_COMMON_ARGS --trait1-file ./sums/adhd_qc_noMHC.csv.gz --out ./fit/adhd.fit;
${MIXER_PY} test1 $MIXER_COMMON_ARGS --trait1-file ./sums/adhd_qc_noMHC.csv.gz --load-params ./fit/adhd.fit.json --out ./fit/adhd.test;
${MIXER_PY} fit1 $MIXER_COMMON_ARGS --trait1-file ./sums/testosterone_qc_noMHC.csv.gz --out ./fit/testosterone.fit;
${MIXER_PY} test1 $MIXER_COMMON_ARGS --trait1-file ./sums/testosterone_qc_noMHC.csv.gz --load-params ./fit/testosterone.fit.json --out ./fit/testosterone.test;
${MIXER_PY} fit2 $MIXER_COMMON_ARGS  --trait1-file ./sums/testosterone_qc_noMHC.csv.gz --trait2-file ./sums/adhd_qc_noMHC.csv.gz --trait1-params ./fit/testosterone.fit.json --trait2-params ./fit/adhd.fit.json --out ./fit/testosterone_vs_adhd.fit;
${MIXER_PY} test2 $MIXER_COMMON_ARGS --trait1-file ./sums/testosterone_qc_noMHC.csv.gz --trait2-file ./sums/adhd_qc_noMHC.csv.gz --load-params ./fit/testosterone_vs_adhd.fit.json --out ./fit/testosterone_vs_adhd.test;

cd fit/
export MIXER_FIGURE="singularity exec --home /data2/home/crcyj/mixer/fit:/home ${MIXER_SIF} python /tools/mixer/precimed/mixer_figures.py"
${MIXER_FIGURE} combine --json testosterone_vs_adhd.fit.json --out testosterone_vs_adhd.fit;
${MIXER_FIGURE} combine --json testosterone_vs_adhd.test.json --out testosterone_vs_adhd.test;
${MIXER_FIGURE} two --json-fit testosterone_vs_adhd.fit.json --json-test testosterone_vs_adhd.test.json --out testosterone_adhd_m --statistic mean std --trait1 TT --trait2 ADHD --ext svg;