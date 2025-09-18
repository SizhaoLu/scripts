#!/usr/bin/env bash
# note: this script filters the bam file for specific position (in this case Klf4 gene region) and downsample the file to 4% (the -s 0.04) part.
while read sample; do
    echo "Processing $sample..."
    samtools view -b -h -s 0.04 "${sample}.bam" "4:55527143-55532466" > "${sample}_filtered_klf4.bam"
    samtools index "${sample}_filtered_klf4.bam"
done < samples_exp3.txt
