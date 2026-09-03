#!/usr/bin/env bash

set -euo pipefail

# Usage:
#   ./STAR_create_count_mtx.sh unstranded
#   ./STAR_create_count_mtx.sh fr-secondstrand
#   ./STAR_create_count_mtx.sh fr-firststrand
#
# RSeQC infer_experiment.py mapping:
#
#   fr-secondstrand (FR):
#       1++,1--,2+-,2-+
#       -> STAR ReadsPerGene.out.tab column 3
#
#   fr-firststrand (RF):
#       1+-,1-+,2++,2--
#       -> STAR ReadsPerGene.out.tab column 4
#
#   unstranded:
#       -> STAR ReadsPerGene.out.tab column 2

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 {unstranded|fr-secondstrand|fr-firststrand}"
    exit 1
fi

STRANDNESS="$1"

case "$STRANDNESS" in
    unstranded)
        COUNT_COL=2
        ;;
    fr-secondstrand)
        COUNT_COL=3
        ;;
    fr-firststrand)
        COUNT_COL=4
        ;;
    *)
        echo "Error: invalid strandness option: $STRANDNESS"
        echo
        echo "Valid options:"
        echo "  unstranded"
        echo "  fr-secondstrand"
        echo "  fr-firststrand"
        exit 1
        ;;
esac

mkdir -p tmp

for sample in $(cat samples.txt); do
    echo "Processing ${sample}"

    tail -n +5 "align/${sample}_ReadsPerGene.out.tab" \
        | cut -f"${COUNT_COL}" \
        > "tmp/${sample}.count"

    sed -i "1s/^/${sample}\n/" "tmp/${sample}.count"
done

STR=""

for i in $(cat samples.txt); do
    STR="${STR}tmp/${i}.count "
done

paste $STR > tmp/tmp.out

# Generate the gene list column
line=$(head -n 1 samples.txt)

tail -n +5 "align/${line}_ReadsPerGene.out.tab" \
    | cut -f1 \
    > tmp/geneids.txt

sed -i '1s/^/Gene\n/' tmp/geneids.txt

paste tmp/geneids.txt tmp/tmp.out > ./final_count_table.txt

echo
echo "Done."
echo "Strandness: ${STRANDNESS}"
echo "Using STAR ReadsPerGene.out.tab column: ${COUNT_COL}"
echo "Output: final_count_table.txt"
