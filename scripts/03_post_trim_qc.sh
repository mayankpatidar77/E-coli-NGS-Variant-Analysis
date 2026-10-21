#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 3: Check read quality after fastp trimming.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
DATA_DIR="$NGS_ROOT/data"
OUT_DIR="$NGS_ROOT/result/qc/post_trim"
R1="$DATA_DIR/SRR40197980_R1.trimmed.fastq"
R2="$DATA_DIR/SRR40197980_R2.trimmed.fastq"

for f in "$R1" "$R2"; do
    [[ -s "$f" ]] || { echo "ERROR: Missing trimmed input: $f" >&2; exit 1; }
done
command -v fastqc >/dev/null 2>&1 || { echo "ERROR: FastQC is not installed or not on PATH." >&2; exit 1; }

mkdir -p "$OUT_DIR"
fastqc --threads 2 --outdir "$OUT_DIR" "$R1" "$R2"
echo "Post-trimming FastQC reports written to: $OUT_DIR"
