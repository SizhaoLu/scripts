#!/usr/bin/env bash
mkdir -p tmp

for sample in `cat samples.txt`; do
    echo ${sample}
    cat align/${sample}_ReadsPerGene.out.tab | tail -n +5 | cut -f4 > tmp/${sample}.count
    sed -i "1s/^/${sample}\n/" tmp/${sample}.count
done

STR=""
for i in `cat samples.txt`
do
    STR=$STR"tmp/"$i".count "
done

paste $STR > tmp/tmp.out

# Generate the gene list column
line=$(head -n 1 samples.txt)
tail -n +5 align/${line}_ReadsPerGene.out.tab | cut -f1 > tmp/geneids.txt
sed -i '1s/^/Gene\n/' tmp/geneids.txt

paste tmp/geneids.txt tmp/tmp.out > tmp/final_count_table.txt
