#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 4: Align trimmed paired-end reads with BWA-MEM, then create sorted/indexed BAM.
# This script writes SAM/BAM files under ~/NGS/result/alignment.
# It uses 2 threads to be mindful of the laptop's limited resources.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
REF="$NGS_ROOT/reference/reference.fasta"
R1="$NGS_ROOT/data/SRR40197980_R1.trimmed.fastq"
R2="$NGS_ROOT/data/SRR40197980_R2.trimmed.fastq"
OUT_DIR="$NGS_ROOT/result/alignment"
SAM="$OUT_DIR/SRR40197980.sam"
BAM="$OUT_DIR/SRR40197980.bam"
SORTED_BAM="$OUT_DIR/SRR40197980.sorted.bam"

for f in "$REF" "$R1" "$R2"; do
    [[ -s "$f" ]] || { echo "ERROR: Missing or empty input: $f" >&2; exit 1; }
done
command -v bwa >/dev/null 2>&1 || { echo "ERROR: BWA is not installed or not on PATH." >&2; exit 1; }
command -v samtools >/dev/null 2>&1 || { echo "ERROR: SAMtools is not installed or not on PATH." >&2; exit 1; }

# BWA index files should exist beside the reference; create them if needed.
if [[ ! -s "${REF}.bwt" ]]; then
    echo "BWA index not found; creating it for $REF"
    bwa index "$REF"
fi

mkdir -p "$OUT_DIR"
bwa mem -t 2 "$REF" "$R1" "$R2" > "$SAM"
samtools view -@ 2 -b -o "$BAM" "$SAM"
samtools sort -@ 2 -o "$SORTED_BAM" "$BAM"
samtools index "$SORTED_BAM"

echo "Sorted BAM: $SORTED_BAM"
echo "BAM index:  ${SORTED_BAM}.bai"
