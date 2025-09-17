#!/usr/bin/env bash
# takes input of a samples.txt with sample list.
# a list of barcodes of interest should be saved in a txt file with matching name for the bam file
while read sample; do
    {
        samtools view -H "${sample}.bam"
        samtools view "${sample}.bam" | LC_ALL=C grep -F -f "${sample}.txt"
    } | samtools view -b - > "${sample}_filtered.bam"
    samtools index "${sample}_filtered.bam"
done < samples.txt
