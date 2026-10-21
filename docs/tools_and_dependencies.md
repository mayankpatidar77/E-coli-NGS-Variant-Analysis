# Tools and Dependencies

## 1. Purpose

This document describes the software required to run the E. coli NGS variant analysis pipeline, including each tool's role, basic usage, and verification commands.

## 2. Required Tools

| Tool | Purpose | Pipeline stage |
|---|---|---|
| FastQC | Assess sequencing-read quality | Raw and post-trimming QC |
| fastp | Trim adapters and filter reads | Read preprocessing |
| BWA | Align reads against the reference genome | Alignment |
| SAMtools | Process BAM files and calculate alignment statistics | Alignment QC |
| BCFtools | Call, filter, and manipulate variants | Variant analysis |
| Java | Runtime required by the configured SnpEff installation | Annotation |
| SnpEff | Predict potential effects of genetic variants | Annotation |
| Bash | Execute pipeline scripts | Workflow execution |
| Conda | Manage the software environment | Environment setup |

## 3. Verify Tool Availability

Activate the environment:

```bash
conda activate ngs
```

Check command-line tools:

```bash
fastqc --version
fastp --version
bwa
samtools --version
bcftools --version
java -version
```

Check SnpEff using the invocation configured in the project scripts.

## 4. Basic Tool Instructions

### FastQC

Input: FASTQ files.

Purpose: examine read quality and potential sequencing issues.

Typical command:

```bash
fastqc sample_R1.fastq sample_R2.fastq -o qc_reports/
```

### fastp

Input: paired-end FASTQ files.

Purpose: trim and filter reads according to configured parameters.

Typical command:

```bash
fastp \
  -i sample_R1.fastq -I sample_R2.fastq \
  -o trimmed_R1.fastq -O trimmed_R2.fastq \
  -h fastp_report.html -j fastp_report.json
```

### BWA

Input: trimmed reads and a reference genome with the required index.

Purpose: align sequencing reads against the reference.

A typical paired-end alignment command is:

```bash
bwa mem reference.fasta trimmed_R1.fastq trimmed_R2.fastq
```

### SAMtools

Purpose: process alignments, sort and index BAM files, and summarize mapping statistics.

Typical commands:

```bash
samtools sort -o sample.sorted.bam sample.bam
samtools index sample.sorted.bam
samtools flagstat sample.sorted.bam
samtools stats sample.sorted.bam
```

### BCFtools

Purpose: generate and filter candidate variant records.

Common commands include `mpileup`, `call`, `filter`, and `query`. Exact options must match the project's existing variant-calling and filtering scripts.

### SnpEff

Purpose: annotate variants using a compatible genome annotation database.

The configured database, reference compatibility, and SnpEff command should be documented before annotation is performed.

## 5. Important Notes

- Use the versions tested with the project.
- Check reference genome and annotation database compatibility.
- Use the project scripts for the complete workflow rather than running isolated example commands without checking paths.
- The commands above are general examples; filenames and output directories must be adapted to the local environment.

