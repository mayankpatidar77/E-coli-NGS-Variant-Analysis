
#!/usr/bin/env bash
set -Eeuo pipefail

NGS_ROOT="${NGS_ROOT:-$HOME/NGS2}"
DB="PNUSAE230491"
DATA_DIR="${SNPEFF_DATA_DIR:-$NGS_ROOT/snpeff_data}"
DB_DIR="$DATA_DIR/$DB"
CONFIG="${SNPEFF_CONFIG:-}"

if [[ -z "$CONFIG" && -n "${CONDA_PREFIX:-}" ]]; then
    CONFIG="$(find "$CONDA_PREFIX" -name snpEff.config \
        -type f -print -quit 2>/dev/null || true)"
fi

echo "Checking custom SnpEff database: $DB"
echo "Database directory: $DB_DIR"

command -v snpEff >/dev/null 2>&1 || {
    echo "ERROR: Activate the Conda environment containing SnpEff."
    exit 1
}

[[ -n "$CONFIG" && -s "$CONFIG" ]] || {
    echo "ERROR: SnpEff config not found."
    echo "Set SNPEFF_CONFIG to the correct config file."
    exit 1
}

[[ -d "$DB_DIR" ]] || {
    echo "ERROR: Database directory does not exist: $DB_DIR"
    exit 1
}

# Check for the compiled database used by SnpEff.
[[ -s "$DB_DIR/snpEffectPredictor.bin" ]] || {
    echo "ERROR: Compiled database file is missing."
    echo "The database may not have been built successfully."
    exit 1
}

# Verify the genome identifier is declared in the config.
grep -Eq "^[[:space:]]*${DB//./\\.}[.]genome[[:space:]]*:" \
    "$CONFIG" || {
    echo "ERROR: Genome identifier $DB is not declared in $CONFIG"
    exit 1
}

echo "Database files and configuration checks passed."
echo "Next: verify compatibility with the reference and test annotation."

