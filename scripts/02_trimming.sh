#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 2: Paired-end read preprocessing with fastp.
# Parameters follow the successful command in the shell history:
#   -f 14 = trim 14 bases from the FRONT of Read 1
#   -t 5  = trim 5 bases from the TAIL of Read 1
#   -q 20 = quality threshold; -n 2 = max ambiguous bases; -l 70 = min read length
# Note: -f and -t are Read 1 options in fastp. They do not automatically mean
# the same trimming was applied to Read 2.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
DATA_DIR="$NGS_ROOT/data"
OUT_DIR="$NGS_ROOT/result/qc"
R1="$DATA_DIR/SRR40197980_1.fastq"
R2="$DATA_DIR/SRR40197980_2.fastq"
TRIM_R1="$DATA_DIR/SRR40197980_R1.trimmed.fastq"
TRIM_R2="$DATA_DIR/SRR40197980_R2.trimmed.fastq"
HTML="$OUT_DIR/SRR40197980.fastp.html"
JSON="$OUT_DIR/SRR40197980.fastp.json"

for f in "$R1" "$R2"; do
    [[ -s "$f" ]] || { echo "ERROR: Missing or empty input: $f" >&2; exit 1; }
done
command -v fastp >/dev/null 2>&1 || { echo "ERROR: fastp is not installed or not on PATH." >&2; exit 1; }

mkdir -p "$OUT_DIR"
fastp \
    --thread 2 \
    -i "$R1" -I "$R2" \
    -o "$TRIM_R1" -O "$TRIM_R2" \
    -f 14 -t 5 -q 20 -n 2 -l 70 \
    -h "$HTML" -j "$JSON"

echo "Trimmed R1: $TRIM_R1"
echo "Trimmed R2: $TRIM_R2"
echo "fastp HTML report: $HTML"
echo "fastp JSON report: $JSON"
