#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 1: Raw-read quality control with FastQC.
# Expected inputs:
#   ~/NGS2/data/SRR40197980_1.fastq
#   ~/NGS2/data/SRR40197980_2.fastq
# Run from any directory; set NGS_ROOT if your analysis folder is elsewhere.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
DATA_DIR="$NGS_ROOT/data"
OUT_DIR="$NGS_ROOT/result/qc/raw"

R1="$DATA_DIR/SRR40197980_1.fastq"
R2="$DATA_DIR/SRR40197980_2.fastq"

for f in "$R1" "$R2"; do
    [[ -s "$f" ]] || { echo "ERROR: Missing or empty input: $f" >&2; exit 1; }
done
command -v fastqc >/dev/null 2>&1 || { echo "ERROR: FastQC is not installed or not on PATH." >&2; exit 1; }

mkdir -p "$OUT_DIR"
fastqc --threads 2 --outdir "$OUT_DIR" "$R1" "$R2"
echo "Raw FastQC reports written to: $OUT_DIR"
