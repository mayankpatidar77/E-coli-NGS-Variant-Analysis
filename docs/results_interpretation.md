# Results Interpretation

## 1. Summary of the Recorded Run

The completed practice run processed paired-end *Escherichia coli* sequencing data identified by accession `SRR40197980`.

| Metric | Result |
|---|---:|
| Raw paired-end read pairs | 427,246 |
| Paired-end read pairs after trimming | 387,971 |
| Approximate read-pair retention | 90.82% |
| Post-trimming R1 Q30 | 95.73% |
| Post-trimming R2 Q30 | 88.61% |
| Raw variant records | 7 |
| Filtered variant records | 5 |

These figures should be treated as run-specific observations.

## 2. Read Retention

The approximate paired-read retention was calculated as:

\[
\text{Retention} =
\frac{387,971}{427,246}\times100
\approx90.81\%
\]

Approximately 9.19% of the original read pairs were not retained as paired reads after trimming.

This difference does not automatically indicate failure. Read removal can result from adapter trimming, quality filtering, length filtering, or other configured preprocessing rules. The fastp summary should be consulted to establish the actual reasons.

## 3. Interpretation of Q30

Q30 represents a base quality score of 30 or higher, corresponding to an estimated base-call error probability of 0.1% under the Phred quality model.

The recorded post-trimming Q30 values were:

- R1: 95.73%
- R2: 88.61%

R1 had a higher proportion of bases at Q30 or above than R2 in this run. This difference warrants checking the individual FastQC reports and fastp statistics.

Q30 is a base-level quality metric. It does not directly measure the proportion of correct variant calls.

## 4. Variant Filtering

The run generated 7 raw variant records and 5 filtered variant records.

The difference is 2 records. The reduction relative to the raw record count is:

\[
\frac{7-5}{7}\times100
\approx28.57\%
\]

This is a record-count reduction, not a measurement of the percentage of erroneous variants removed. That conclusion would require independent evidence about the truth of each call.

The precise filtering rules must be inspected in the variant-filtering script.

## 5. Variant Annotation

The annotated VCF and SnpEff summary provide predicted effects according to the configured annotation database.

Annotation categories are predictions based on the available reference and gene annotation. They do not independently prove a functional effect, phenotype, pathogenicity, or evolutionary significance.

Database compatibility should be established before interpreting gene-level consequences.

## 6. Candidate Variant Review

Candidate-site review should consider:

- Read depth at the variant position.
- Number and proportion of reads supporting the alternate allele.
- Support from both sequencing strands.
- Mapping quality and base quality.
- Local alignment and nearby sequence context.
- Compatibility between the reference genome and annotation database.

The resulting evidence should be reviewed before any candidate is described as a confirmed biological variant.

## 7. Overall Conclusion

The recorded run demonstrates a functioning sequence of NGS processing steps from raw read quality control through variant annotation and candidate-site review.

The results show measurable preprocessing and filtering outputs. Further technical review and reference/database verification are required before making biological claims about the retained variant records.

