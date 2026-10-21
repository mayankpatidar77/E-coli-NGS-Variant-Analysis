# Methodology

## 1. Project Objective

The objective of this project is to implement a reference-based NGS DNA-seq analysis workflow for paired-end *Escherichia coli* sequencing data. The workflow processes raw reads, assesses sequencing quality, aligns reads to a reference genome, calls and filters variants, annotates variant effects, and prepares candidate-site evidence for further review.

## 2. Dataset

- Sample accession: `SRR40197980`
- Organism: *Escherichia coli*
- Sequencing layout: paired-end
- Input format: FASTQ
- Reference file used by the workflow: `reference.fasta`

The reference accession and version should be recorded after verification against the original reference source.

## 3. Analysis Stages

### Stage 1: Raw Read Quality Control

**Tool:** FastQC

Raw FASTQ files are examined for quality-score distribution, per-base sequence quality, adapter content, sequence composition, and other QC characteristics.

Purpose: identify potential sequencing-quality issues before preprocessing.

### Stage 2: Read Trimming

**Tool:** fastp

Paired-end reads are processed using the trimming and quality parameters defined in the project scripts.

Purpose: remove unwanted sequence and low-quality regions according to the configured settings.

The selected parameters should be documented with their rationale and corresponding fastp report.

### Stage 3: Post-Trimming Quality Control

**Tool:** FastQC

The trimmed read files are assessed again to determine whether their quality characteristics changed after preprocessing.

Purpose: evaluate the results of trimming rather than assuming that preprocessing automatically improved every metric.

### Stage 4: Reference-Based Alignment

**Tool:** BWA

Trimmed paired-end reads are aligned against the configured reference genome. Alignment records are written for downstream processing.

Purpose: establish the genomic positions at which sequencing reads align to the reference.

### Stage 5: Alignment Processing and Quality Control

**Tool:** SAMtools

Alignment files are processed into sorted and indexed BAM format. Mapping statistics are generated using available SAMtools commands.

Purpose: evaluate mapping performance, paired-read alignment, and alignment characteristics before variant calling.

### Stage 6: Variant Calling

**Tool:** BCFtools

The alignment and reference genome are used to generate candidate variant records. Intermediate BCF and VCF files are retained in the local analysis workspace.

Purpose: identify sequence differences supported by the aligned reads.

### Stage 7: Variant Filtering

**Tool:** BCFtools

The raw variant calls are filtered according to the criteria defined in the filtering script.

Purpose: reduce the candidate set based on the chosen quality rules.

The exact filtering expressions and thresholds should be taken from `scripts/07_variant_filtering.sh`; they should not be inferred from the final variant count.

### Stage 8: Variant Annotation

**Tool:** SnpEff

Filtered variants are annotated using the configured organism-specific database.

Purpose: predict potential functional consequences of the variants based on the database's reference and annotation.

The compatibility of the annotation database with the alignment reference must be verified.

### Stage 9: Candidate Variant Review

The workflow prepares candidate-site metrics and read-level evidence for additional review.

Purpose: examine evidence supporting candidate calls and identify issues requiring further validation.

Relevant checks include depth, alternate-allele support, strand distribution, mapping quality, and reference compatibility.

## 4. Software and Environment

The workflow was developed in Linux using WSL2 and a Conda environment named `ngs`. It uses FastQC, fastp, BWA, SAMtools, BCFtools, Java, and SnpEff.

Exact software versions should be recorded from the environment used for the published run.

## 5. Reproducibility

The analysis scripts and documentation are maintained in the GitHub repository. Raw sequencing data, the reference genome, and generated analysis outputs are stored separately in the local `NGS2/` workspace.

Reproduction requires compatible input files, a compatible reference genome and annotation database, the required software, and correctly configured paths.

