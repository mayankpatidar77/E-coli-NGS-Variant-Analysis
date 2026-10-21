# Workflow and Execution Roadmap

## Overview

The workflow is divided into nine Bash-script stages, coordinated by `run_pipeline.sh`.

The scripts are stored in `scripts/`, while sequencing inputs and generated outputs are stored in the separate local `NGS2/` directory.

## Execution Flow

```text
[00] Activate environment and verify paths
                 |
                 v
[01] Raw QC — FastQC
                 |
                 v
[02] Trimming — fastp
                 |
                 v
[03] Post-trimming QC — FastQC
                 |
                 v
[04] Alignment — BWA
                 |
                 v
[05] Alignment QC — SAMtools
                 |
                 v
[06] Variant calling — BCFtools
                 |
                 v
[07] Variant filtering — BCFtools
                 |
                 v
[08] Annotation — SnpEff
                 |
                 v
[09] Candidate variant review
                 |
                 v
[10] Final output and reproducibility audit
```

## Stage-by-Stage Inputs and Outputs

| Index | Script | Input | Main output |
|---|---|---|---|
| 01 | `01_raw_qc.sh` | Raw paired FASTQ | Raw FastQC reports |
| 02 | `02_trimming.sh` | Raw paired FASTQ | Trimmed paired FASTQ |
| 03 | `03_post_trim_qc.sh` | Trimmed FASTQ | Post-trimming FastQC reports |
| 04 | `04_alignment.sh` | Trimmed FASTQ and reference | SAM/BAM alignment |
| 05 | `05_alignment_qc.sh` | Alignment files | Sorted/indexed BAM and QC statistics |
| 06 | `06_variant_calling.sh` | Alignment and reference | Raw variant records |
| 07 | `07_variant_filtering.sh` | Raw variant calls | Filtered VCF and variant table |
| 08 | `08_annotation.sh` | Filtered variants and annotation database | Annotated VCF and SnpEff summary |
| 09 | `09_candidate_variant_review.sh` | Candidate calls and alignment evidence | Candidate-site review files |

## Local Path Configuration

The documented paths for the current workspace are:

```bash
PROJECT_DIR="/home/MAYANK/E-coli-NGS-Variant-Analysis"
DATA_DIR="/home/MAYANK/NGS2/data"
REFERENCE_DIR="/home/MAYANK/NGS2/reference"
RESULT_DIR="/home/MAYANK/NGS2/result"
SAMPLE="SRR40197980"
```

These values describe the current layout. Confirm that the scripts use these paths before execution.

## Pre-Execution Checks

1. Activate the required Conda environment.
2. Verify that raw R1 and R2 files exist.
3. Verify the reference genome and required indexes.
4. Confirm that all required tools are installed.
5. Check SnpEff database availability and compatibility.
6. Inspect the master runner and confirm that it invokes the stages in the correct order.
7. Check Bash syntax before running.

## Execution

From the repository root:

```bash
conda activate ngs
cd /home/MAYANK/E-coli-NGS-Variant-Analysis

bash -n run_pipeline.sh
bash run_pipeline.sh
```

The commands above assume the runner is designed to be executed with Bash. Check the runner's contents before execution, particularly how it handles failures and existing output files.

## Post-Execution Checks

- Confirm that every stage completed successfully.
- Inspect the generated log.
- Review raw and post-trimming QC reports.
- Review alignment statistics.
- Compare raw and filtered variant counts.
- Inspect the annotated VCF and SnpEff summary.
- Review candidate-site evidence.
- Record the software versions and reference/database provenance.

## Output Locations

The main outputs are stored under:

`/home/MAYANK/NGS2/result/`

The exact subdirectories and filenames are defined by the existing scripts. The GitHub repository documents the workflow but is not the storage location for the full analysis output.

