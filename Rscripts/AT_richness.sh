#!/bin/bash

# Check for input FASTA
if [ $# -eq 0 ]; then
    echo "Usage: $0 <genome.fasta>"
    exit 1
fi

FASTA_INPUT=$1

NAME=$(basename "$FASTA_INPUT")
NAME="${NAME%.*}"

samtools faidx "$FASTA_INPUT"

bedtools makewindows -g "${FASTA_INPUT}.fai" -w 1000 > "${NAME}_1kb_windows.bed"

bedtools nuc -fi "$FASTA_INPUT" -bed "${NAME}_1kb_windows.bed" | awk 'BEGIN{OFS="\t"} NR>1 {print $1, $2, $3, $4}' > "${NAME}_at_richness.bed"
