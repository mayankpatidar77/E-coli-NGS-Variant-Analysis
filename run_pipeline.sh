
#!/usr/bin/env bash
set -Eeuo pipefail

# E. coli NGS Variant Analysis: master pipeline runner

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$PROJECT_DIR/scripts"
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$LOG_DIR/pipeline_${TIMESTAMP}.log"

# Save terminal output and errors to a timestamped log as well.
exec > >(tee -a "$LOG_FILE") 2>&1

STEPS=(
    "01_raw_qc.sh"
    "02_trimming.sh"
    "03_post_trim_qc.sh"
    "04_alignment.sh"
    "05_alignment_qc.sh"
    "06_variant_calling.sh"
    "07_variant_filtering.sh"
    "08_annotation.sh"
    "09_candidate_variant_review.sh"
)

CURRENT_STEP="initialization"

on_error() {
    local exit_code=$?
    echo
    echo "ERROR: Pipeline stopped during: $CURRENT_STEP"
    echo "Exit code: $exit_code"
    echo "Check the log: $LOG_FILE"
    exit "$exit_code"
}

trap on_error ERR

echo "============================================"
echo "       E. COLI NGS ANALYSIS PIPELINE"
echo "============================================"
echo "Project: $PROJECT_DIR"
echo "Started: $(date)"
echo "Log:     $LOG_FILE"
echo

# Check that every script exists before starting.
for script in "${STEPS[@]}"; do
    if [[ ! -f "$SCRIPT_DIR/$script" ]]; then
        echo "ERROR: Missing script: $SCRIPT_DIR/$script"
        exit 1
    fi
done

# Run each stage sequentially from the project root.
cd "$PROJECT_DIR"

for script in "${STEPS[@]}"; do
    CURRENT_STEP="$script"

    echo
    echo "--------------------------------------------"
    echo "STARTING: $script"
    echo "Time: $(date)"
    echo "--------------------------------------------"

    bash "$SCRIPT_DIR/$script"

    echo "SUCCESS: $script"
    echo "Finished: $(date)"
done

echo
echo "============================================"
echo "PIPELINE COMPLETED SUCCESSFULLY"
echo "Finished: $(date)"
echo "Log saved to: $LOG_FILE"
echo "============================================"

