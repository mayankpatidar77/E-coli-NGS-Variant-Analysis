#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 7: Apply the filtering thresholds used in the project:
# QUAL >= 30, INFO/DP >= 10, INFO/MQ >= 30.
# Passing these thresholds prioritizes calls; it does not experimentally validate them.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
OUT_DIR="$NGS_ROOT/result/variants"
SAMPLE="SRR40197980"
RAW="$OUT_DIR/${SAMPLE}.raw.vcf.gz"
FILTERED="$OUT_DIR/${SAMPLE}.filtered.vcf.gz"

[[ -s "$RAW" ]] || { echo "ERROR: Raw VCF not found: $RAW" >&2; exit 1; }
command -v bcftools >/dev/null 2>&1 || { echo "ERROR: BCFtools is not installed or not on PATH." >&2; exit 1; }

bcftools view -i 'QUAL>=30 && INFO/DP>=10 && INFO/MQ>=30' \
    -Oz -o "$FILTERED" "$RAW"
bcftools index -f "$FILTERED"

bcftools view -H "$RAW" | wc -l > "$OUT_DIR/${SAMPLE}.raw_variant_count.txt"
bcftools view -H "$FILTERED" | wc -l > "$OUT_DIR/${SAMPLE}.filtered_variant_count.txt"

bcftools query \
    -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\t%INFO/MQ[\t%GT]\n' \
    "$FILTERED" > "$OUT_DIR/${SAMPLE}.filtered_variants.tsv"

# Separate SNP and indel subsets for convenient review.
bcftools view -v snps -Oz -o "$OUT_DIR/${SAMPLE}.filtered.snps.vcf.gz" "$FILTERED"
bcftools index -f "$OUT_DIR/${SAMPLE}.filtered.snps.vcf.gz"
bcftools view -v indels -Oz -o "$OUT_DIR/${SAMPLE}.filtered.indels.vcf.gz" "$FILTERED"
bcftools index -f "$OUT_DIR/${SAMPLE}.filtered.indels.vcf.gz"

echo "Raw records:      $(cat "$OUT_DIR/${SAMPLE}.raw_variant_count.txt")"
echo "Filtered records: $(cat "$OUT_DIR/${SAMPLE}.filtered_variant_count.txt")"
echo "Filtered summary: $OUT_DIR/${SAMPLE}.filtered_variants.tsv"
