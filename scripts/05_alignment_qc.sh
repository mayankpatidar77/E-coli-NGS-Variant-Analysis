#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 5: Alignment quality metrics from the sorted BAM.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
BAM="$NGS_ROOT/result/alignment/SRR40197980.sorted.bam"
OUT_DIR="$NGS_ROOT/result/alignment_qc"
SAMPLE="SRR40197980"

[[ -s "$BAM" ]] || { echo "ERROR: Sorted BAM not found: $BAM" >&2; exit 1; }
[[ -s "${BAM}.bai" ]] || { echo "ERROR: BAM index not found: ${BAM}.bai" >&2; exit 1; }
command -v samtools >/dev/null 2>&1 || { echo "ERROR: SAMtools is not installed or not on PATH." >&2; exit 1; }

mkdir -p "$OUT_DIR"
samtools flagstat "$BAM" > "$OUT_DIR/${SAMPLE}.flagstat.txt"
samtools idxstats "$BAM" > "$OUT_DIR/${SAMPLE}.idxstats.txt"
samtools stats "$BAM" > "$OUT_DIR/${SAMPLE}.stats.txt"

echo "Alignment QC reports written to: $OUT_DIR"
echo "Review ${OUT_DIR}/${SAMPLE}.flagstat.txt for mapped and properly-paired percentages."
