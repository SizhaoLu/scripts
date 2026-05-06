#!/usr/bin/env bash
for f in align/*_ReadsPerGene.out.tab; do
    basename ${f} _ReadsPerGene.out.tab
done > samples.txt
