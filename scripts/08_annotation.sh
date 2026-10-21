#!/usr/bin/env bash
set -Eeuo pipefail

# Stage 8: Annotate the filtered VCF with the custom SnpEff database used in this project.
# The SnpEff database must already be built and available in the configured data directory.
# Activate the Conda environment that contains SnpEff before running this script.

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
OUT_DIR="$NGS_ROOT/result/variants"
SAMPLE="SRR40197980"
DB="PNUSAE230491"
INPUT="$OUT_DIR/${SAMPLE}.filtered.vcf.gz"
ANNOTATED="$OUT_DIR/${SAMPLE}.annotated.vcf"
SUMMARY="$OUT_DIR/${SAMPLE}.snpeff_summary.html"
GENES="$OUT_DIR/${SAMPLE}.snpeff_summary.genes.txt"
DATA_DIR="${SNPEFF_DATA_DIR:-$NGS_ROOT/snpeff_data}"

[[ -s "$INPUT" ]] || { echo "ERROR: Filtered VCF not found: $INPUT" >&2; exit 1; }
command -v snpEff >/dev/null 2>&1 || command -v snpeff >/dev/null 2>&1 || {
    echo "ERROR: SnpEff is not on PATH. Activate the Conda environment containing SnpEff." >&2
    exit 1
}
[[ -d "$DATA_DIR/$DB" ]] || {
    echo "ERROR: Expected SnpEff database directory missing: $DATA_DIR/$DB" >&2
    echo "Confirm the custom database has been built before annotation." >&2
    exit 1
}

mkdir -p "$OUT_DIR"
SNPEFF_BIN="$(command -v snpEff || command -v snpeff)"
CONFIG="${SNPEFF_CONFIG:-}"
if [[ -z "$CONFIG" && -n "${CONDA_PREFIX:-}" ]]; then
    CONFIG="$(find "$CONDA_PREFIX" -name snpEff.config -type f -print -quit 2>/dev/null || true)"
fi
if [[ -z "$CONFIG" || ! -s "$CONFIG" ]]; then
    echo "ERROR: SnpEff config not found. Set SNPEFF_CONFIG to the config file used to build $DB." >&2
    exit 1
fi

"$SNPEFF_BIN" \
    -c "$CONFIG" \
    -dataDir "$DATA_DIR" \
    -stats "$SUMMARY" \
    "$DB" "$INPUT" > "$ANNOTATED"

# SnpEff may create this file depending on its version/configuration.


echo "Annotated VCF: $ANNOTATED"
echo "SnpEff HTML summary: $SUMMARY"
echo "Confirm the database/reference annotation compatibility before biological interpretation."
