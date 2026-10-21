# E. coli NGS Variant Analysis Pipeline

A command-line bioinformatics project for analyzing paired-end Illumina sequencing reads from *Escherichia coli* using Linux, Bash, and standard NGS analysis tools.

## Project Overview

This project demonstrates an end-to-end DNA sequencing analysis workflow, from raw-read quality control to variant calling, filtering, annotation, and candidate variant review.

The analysis uses **SRR40197980** as the sequencing dataset and a reference genome prepared for read alignment.

**Main objectives**
- Evaluate raw sequencing-read quality.
- Trim low-quality bases and prepare reads for analysis.
- Align paired-end reads against a reference genome.
- Assess alignment quality and mapping statistics.
- Identify and filter candidate genetic variants.
- Annotate variants to investigate their potential effects.
- Review selected candidate variants using read-level evidence.

## Workflow

```text
Raw FASTQ Reads
       |
       v
01. Raw Read Quality Control
       | FastQC
       v
02. Read Trimming and Filtering
       | fastp
       v
03. Post-Trimming Quality Control
       | FastQC
       v
04. Read Alignment
       | BWA-MEM
       v
05. Alignment Processing and QC
       | SAMtools
       v
06. Variant Calling
       | BCFtools
       v
07. Variant Filtering
       | BCFtools
       v
08. Variant Annotation
       | SnpEff
       v
09. Candidate Variant Review
```

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Bash | Automates pipeline execution |
| FastQC | Evaluates read quality |
| fastp | Trims and filters sequencing reads |
| BWA | Aligns reads to the reference genome |
| SAMtools | Processes alignments and calculates QC statistics |
| BCFtools | Calls, filters, and queries variants |
| SnpEff | Predicts potential variant effects |
| Java | Runtime dependency for SnpEff |
| Conda | Manages the software environment |
| Linux / WSL2 | Analysis environment |

See [`docs/tools_and_dependencies.md`](docs/tools_and_dependencies.md) for tool instructions and verification commands.

## Key Results

The following results were recorded during the current pipeline run.

| Metric | Result |
|---|---:|
| Raw paired-end read pairs | 427,246 |
| Read pairs after trimming | 387,971 |
| Approximate read-pair retention | 90.82% |
| R1 post-trimming Q30 | 95.73% |
| R2 post-trimming Q30 | 88.61% |
| Raw VCF variant records | 7 |
| Filtered VCF variant records | 5 |

**Interpretation:** Approximately 90.82% of read pairs were retained after trimming. The R1 Q30 percentage was higher than R2, so the read-quality reports should be reviewed individually. Five variant records remained after the configured filtering step.

These are results from the current analysis run, not universal performance benchmarks. Filtered variants are candidate calls and require suitable quality, coverage, reference, and annotation checks before biological interpretation.

## Repository Structure

E-coli-NGS-Variant-Analysis/
├── README.md
├── environment.yml
├── config/
│   └── README.md
├── docs/
│   ├── limitations.md
│   ├── methodology.md
│   ├── results_interpretation.md
│   ├── tools_and_dependencies.md
│   └── workflow.md
├── logs/
│   ├── README.md
│   ├── pipeline_20261020_143944.log
│   └── pipeline_20261020_145918.log
├── results/
│   └── README.md
├── run_pipeline.sh
├── scripts/
│   ├── 01_raw_qc.sh
│   ├── 02_trimming.sh
│   ├── 03_post_trim_qc.sh
│   ├── 04_alignment.sh
│   ├── 05_alignment_qc.sh
│   ├── 06_variant_calling.sh
│   ├── 07_variant_filtering.sh
│   ├── 08_annotation.sh
│   └── 09_candidate_variant_review.sh
└── setup/
    ├── README.md
    └── check_snpeff_db.sh

The repository contains pipeline scripts and documentation. **Sequencing data, reference files, and actual analysis outputs are maintained separately** in the local workspace:

```text
/home/MAYANK/NGS2/
├── data/
├── reference/
├── result/
└── snpeff_data/
```

The `results/README.md` explains the location of local outputs. Large FASTQ files, BAM files, VCF files, reference indexes, and generated reports are not intended to be committed to this repository.

## Running the Pipeline

### 1. Activate the environment

```bash
conda activate ngs
```

### 2. Open the repository

```bash
cd /home/MAYANK/E-coli-NGS-Variant-Analysis
```

### 3. Check the scripts and dependencies

```bash
bash --version
fastqc --version
fastp --version
bwa
samtools --version
bcftools --version
java -version
```

Check SnpEff using the configuration and invocation documented in the project scripts.

### 4. Run the pipeline

```bash
bash run_pipeline.sh
```

Run this command only after confirming that the input files, reference genome, output directories, software dependencies, and configured paths match your local environment.

Review the log files under `logs/` to identify errors and confirm which stages completed successfully.

## Documentation

- [Methodology](docs/methodology.md) — explains the analytical stages and why they are performed.
- [Tools and Dependencies](docs/tools_and_dependencies.md) — describes required tools, their roles, and basic commands.
- [Limitations](docs/limitations.md) — documents limitations and points requiring further validation.
- [Configuration](config/README.md) — documents project configuration and path-related information.
- [Pipeline Scripts](scripts/README.md) — describes the individual Bash scripts.
- [Local Results Information](results/README.md) — explains where the generated analysis outputs are stored.

## Limitations and Quality Considerations

- Results depend on the selected reference genome, sequencing quality, alignment settings, and variant-filtering thresholds.
- The reference genome and SnpEff annotation database must be compatible with the sample and analysis.
- Differences in read quality, sequencing depth, mapping quality, and allele support can affect variant confidence.
- Annotation predicts potential effects; it does not independently establish a biological or clinical consequence.
- Candidate variants require additional evidence before drawing conclusions about their functional significance.

See [`docs/limitations.md`](docs/limitations.md) for further details.

## Learning Outcomes

This project provides practical experience with:

- Linux command-line workflows and Bash scripting.
- FASTQ quality control and read preprocessing.
- Reference-based sequence alignment.
- BAM processing and alignment quality assessment.
- Variant calling, filtering, and annotation.
- Reproducible pipeline organization and technical documentation.

## Environment Setup

The required software dependencies are documented in
[`environment.yml`](environment.yml).

Create the Conda environment using:

```bash
conda env create -f environment.yml
conda activate ngs

## Author

**Mayank Patidar**  
MSc Bioinformatics  
Devi Ahilya Vishwavidyalaya (DAVV), Indore, India

---

*This project is intended for bioinformatics learning and technical demonstration. Reported variants should be interpreted only after appropriate quality control and validation.*
# E-coli-NGS-Variant-Analysis
