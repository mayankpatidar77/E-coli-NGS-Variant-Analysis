#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 6: Haploid bacterial variant calling with BCFtools.
# Creates an mpileup BCF and raw haploid variant calls.
# -Ou streams uncompressed BCF between commands; -Ob writes compressed BCF to disk.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
REF="$NGS_ROOT/reference/reference.fasta"
BAM="$NGS_ROOT/result/alignment/SRR40197980.sorted.bam"
OUT_DIR="$NGS_ROOT/result/variants"
SAMPLE="SRR40197980"

for f in "$REF" "$BAM" "${BAM}.bai"; do
    [[ -s "$f" ]] || { echo "ERROR: Required file missing: $f" >&2; exit 1; }
done
command -v bcftools >/dev/null 2>&1 || { echo "ERROR: BCFtools is not installed or not on PATH." >&2; exit 1; }

mkdir -p "$OUT_DIR"
bcftools mpileup -f "$REF" -Ob -o "$OUT_DIR/${SAMPLE}.mpileup.bcf" "$BAM"
bcftools index -f "$OUT_DIR/${SAMPLE}.mpileup.bcf"

bcftools call -mv --ploidy 1 -Ob \
    -o "$OUT_DIR/${SAMPLE}.haploid.raw.bcf" \
    "$OUT_DIR/${SAMPLE}.mpileup.bcf"
bcftools index -f "$OUT_DIR/${SAMPLE}.haploid.raw.bcf"

bcftools view -Oz \
    -o "$OUT_DIR/${SAMPLE}.raw.vcf.gz" \      
    "$OUT_DIR/${SAMPLE}.haploid.raw.bcf"
bcftools index -f "$OUT_DIR/${SAMPLE}.raw.vcf.gz"

bcftools view -H "$OUT_DIR/${SAMPLE}.raw.vcf.gz" | wc -l \
    > "$OUT_DIR/${SAMPLE}.raw_variant_count.txt"

echo "Raw VCF: $OUT_DIR/${SAMPLE}.raw.vcf.gz"
echo "Raw variant count: $(cat "$OUT_DIR/${SAMPLE}.raw_variant_count.txt")"
