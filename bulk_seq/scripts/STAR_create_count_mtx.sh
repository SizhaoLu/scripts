#!/usr/bin/env bash
mkdir tmp
touch tmp/tmp.out
for sample in `cat samples.txt`; do \
    echo ${sample}
    cat ${sample}_ReadsPerGene.out.tab | tail -n +5 | cut -f4 > tmp/${sample}.count
    sed -i "1s/^/${sample}\n/" tmp/${sample}.count
done
STR=""
for i in `cat samples.txt`
do
    STR=$STR"tmp/"$i".count "
done
paste $STR > tmp/tmp.out
#generate the gene list column
line=$(head -n 1 samples.txt)
tail -n +5 ${line}_ReadsPerGene.out.tab | cut -f1 > tmp/geneids.txt
sed -i '1s/^/Gene\n/' tmp/geneids.txt
paste tmp/geneids.txt tmp/tmp.out > tmp/final_count_table.txt
