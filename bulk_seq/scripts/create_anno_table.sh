#!/usr/bin/env bash

GTF="./gencode.vM23.annotation.gtf"
OUTPUT="./gene_annotation.txt"

mkdir -p tmp
# Extract gene-level attributes from GTF
awk '
$3 == "gene" {
    gene_id = ""; gene_name = ""; gene_type = ""
    for (i = 9; i <= NF; i++) {
        if ($i == "gene_id")   gene_id   = $(i+1)
        if ($i == "gene_name") gene_name = $(i+1)
        if ($i == "gene_type") gene_type = $(i+1)
    }
    gsub(/[";]/, "", gene_id)
    gsub(/[";]/, "", gene_name)
    gsub(/[";]/, "", gene_type)
    if (gene_name == "") gene_name = gene_id
    print gene_id "\t" gene_name "\t" gene_type
}
' ${GTF} > tmp/gene_annotation_noheader.txt

# Add header
echo -e "EnsemblID\tGeneSymbol\tGeneType" | cat - tmp/gene_annotation_noheader.txt > ${OUTPUT}
rm -rf tmp

echo "Done! Annotation table: ${OUTPUT}"
echo "Total genes: $(tail -n +2 ${OUTPUT} | wc -l)"
