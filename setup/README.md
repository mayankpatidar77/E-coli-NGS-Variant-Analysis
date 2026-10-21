# Setup and Environment Verification

## 1. Purpose

The `setup/` directory contains helper scripts for checking the software and annotation resources required by the E. coli NGS Variant Analysis Pipeline.

These checks help identify missing dependencies or configuration problems before running the analysis.

## 2. Directory Contents

| File | Purpose |
|---|---|
| `check_snpeff_db.sh` | Checks the configured SnpEff database setup. |
| `README.md` | Documents setup requirements and verification instructions. |

## 3. Software Requirements

The pipeline uses the following tools:

- **FastQC** — sequencing-read quality control.
- **fastp** — read trimming and filtering.
- **BWA** — reference-based read alignment.
- **SAMtools** — alignment processing and quality statistics.
- **BCFtools** — variant calling and filtering.
- **SnpEff** — variant-effect annotation.
- **Java** — runtime required by SnpEff.
- **Bash and Linux** — pipeline execution environment.
- **Conda** — software environment management.

The project-root `environment.yml` documents the Conda environment specification. See [`../docs/tools_and_dependencies.md`](../docs/tools_and_dependencies.md) for tool details and basic commands.

## 4. Activate the Environment

If the environment already exists:

```bash
conda activate ngs
```

To create an environment from the project specification:

```bash
conda env create -f ../environment.yml
conda activate ngs
```

Run these commands from the repository root when creating the environment, or adjust the path if running them from another directory.

## 5. Verify Software Availability

Check the main tools:

```bash
fastqc --version
fastp --version
bwa
samtools --version
bcftools --version
java -version
```

SnpEff should also be available through the configured installation. Use the same SnpEff command and configuration path as the pipeline scripts.

## 6. Check the SnpEff Database

The pipeline uses a configured SnpEff database named `PNUSAE230491`.

From the repository root, run:

```bash
bash setup/check_snpeff_db.sh
```

Review the script output to determine whether the expected database resources and configuration are available.

**Important:** Finding a database does not by itself prove that it matches the reference genome used for alignment. Confirm reference and annotation compatibility before interpreting predicted variant effects.

## 7. Input and Reference Requirements

Before running the pipeline, confirm that:

1. Both paired-end FASTQ files are available.
2. The reference FASTA file is present at the path configured in the scripts.
3. Required reference indexes are available or can be generated.
4. Output directories are writable.
5. SnpEff is configured with a compatible annotation database.
6. Software versions and paths match the current environment.

The current analysis workspace is separate from the GitHub repository:

```text
/home/MAYANK/NGS2/
├── data/
├── reference/
├── result/
└── snpeff_data/
```

Update configured paths if the workspace changes.

## 8. Troubleshooting

- **Command not found:** Activate the correct Conda environment and check whether the tool is installed.
- **Reference index missing:** Check the reference path and the indexing steps in the alignment script.
- **SnpEff database not found:** Check the SnpEff configuration file and database directory.
- **Annotation mismatch:** Verify that the database annotation corresponds to the intended reference genome.
- **Permission denied:** Check file permissions and confirm that the output directories are writable.

## 9. Recommended Execution Order

1. Activate and verify the software environment.
2. Check the input FASTQ and reference files.
3. Run `check_snpeff_db.sh`.
4. Review the configuration and paths.
5. Execute the pipeline using `run_pipeline.sh` from the repository root.
6. Review the log files and generated outputs.

For the complete analysis sequence, see [`../docs/workflow.md`](../docs/workflow.md).

---

*This directory provides setup and verification helpers. It does not contain the sequencing data or the analysis results.*

