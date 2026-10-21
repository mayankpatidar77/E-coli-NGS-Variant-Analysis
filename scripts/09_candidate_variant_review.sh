#!/usr/bin/env bash
set -Eeuo pipefail

# Optional review of the candidate coaBC site discussed in the project.
# This script summarizes existing evidence; it does not validate the variant.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
BAM="$NGS_ROOT/result/alignment/SRR40197980.sorted.bam"
VCF="$NGS_ROOT/result/variants/SRR40197980.raw.vcf.gz"
CONTIG="ACEYVB010000006.1"
POS="139866"
OUT_DIR="$NGS_ROOT/result/candidate_review"

[[ -s "$BAM" ]] || { echo "ERROR: Sorted BAM not found: $BAM" >&2; exit 1; }
[[ -s "${BAM}.bai" ]] || { echo "ERROR: BAM index not found: ${BAM}.bai" >&2; exit 1; }
[[ -s "$VCF" ]] || { echo "ERROR: Raw VCF not found: $VCF" >&2; exit 1; }
command -v samtools >/dev/null 2>&1 || { echo "ERROR: SAMtools is not installed or not on PATH." >&2; exit 1; }
command -v bcftools >/dev/null 2>&1 || { echo "ERROR: BCFtools is not installed or not on PATH." >&2; exit 1; }

mkdir -p "$OUT_DIR"
samtools mpileup -f "$NGS_ROOT/reference/reference.fasta" \
    -r "${CONTIG}:${POS}-${POS}" "$BAM" \
    > "$OUT_DIR/coaBC_site.mpileup.txt"

samtools view "$BAM" "${CONTIG}:139860-139872" \
    > "$OUT_DIR/coaBC_site_reads.sam"

bcftools query -r "${CONTIG}:${POS}-${POS}" \
    -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\t%INFO/DP4\t%INFO/RPBZ\t%INFO/BQBZ\t%INFO/MQBZ\t%INFO/MQSBZ[\t%GT:%AD:%DP]\n' \
    "$VCF" > "$OUT_DIR/coaBC_site_variant_metrics.tsv"

echo "Candidate-site outputs written to: $OUT_DIR"
echo "Review read orientation/strand balance and depth before drawing conclusions."
