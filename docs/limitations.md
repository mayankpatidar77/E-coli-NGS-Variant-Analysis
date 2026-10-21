# Limitations

## 1. Dataset Scope

This project demonstrates a workflow using one *Escherichia coli* paired-end sequencing dataset. Results from one sample cannot establish general conclusions about other isolates, strains, or organisms.

## 2. Preliminary Variant Calls

The workflow produced 7 raw variant records and 5 filtered variant records in the documented run. These counts describe computational outputs, not independently confirmed mutations.

Filtering does not guarantee that all retained variants are true positives or biologically important.

## 3. Sequencing Quality

The post-trimming Q30 percentages were 95.73% for R1 and 88.61% for R2. The difference warrants inspection of the individual QC reports and trimming summaries.

Q30 alone does not establish the accuracy of every read or variant call.

## 4. Reference Genome Compatibility

Incorrect or incompatible reference sequences can affect alignment, variant coordinates, and downstream interpretation.

The reference accession, version, sequence identity, and provenance should be verified and documented.

## 5. Annotation Database Compatibility

SnpEff annotations depend on the database used. A database built from an incompatible reference or annotation can produce misleading or incomplete functional predictions.

The configured SnpEff database must be checked against the genome used for alignment.

## 6. Variant Filtering

Filtering criteria influence the number and characteristics of retained variant records. Different thresholds can produce different results.

The exact expressions, thresholds, and rationale must be documented from the actual filtering script.

## 7. Candidate Variant Validation

Candidate-site review provides supporting evidence but is not equivalent to independent experimental validation.

Before interpreting a candidate biologically, examine read depth, allele balance, strand support, mapping quality, local alignment characteristics, and possible sequencing artefacts.

## 8. Reproducibility and Portability

The current workflow uses local paths under `/home/MAYANK/NGS2/`. These paths will not necessarily exist on another computer.

Users must configure their own data and reference locations. Tool versions and database provenance should also be documented.

## 9. Data Availability

Large FASTQ files, reference files, alignment files, intermediate variant files, and database assets are maintained outside the GitHub repository in the local `NGS2/` workspace.

The GitHub repository provides the workflow and its documentation; cloning it does not automatically download the dataset or reproduce the results.

## 10. Interpretation Boundary

This project demonstrates practical NGS data-processing and variant-analysis skills. It does not establish the clinical significance, phenotype, pathogenicity, or experimental validity of any retained variant.

