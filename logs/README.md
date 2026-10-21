# Pipeline Logs

## Purpose

This directory is used to record pipeline execution logs for troubleshooting and verification.

The actual logs in the current repository include:

- `pipeline_20261020_143944.log`
- `pipeline_20261020_145918.log`

Logs from these runs are useful for checking execution order, command output, warnings, errors, and stage completion.

## What Logs Can Confirm

A pipeline log can help establish:

- Which stages were attempted.
- Whether commands reported errors.
- Which outputs were generated or referenced.
- Whether the master runner reported successful completion.

A success message alone does not guarantee that all biological results are correct.

## Local Paths

The pipeline uses the project directory:

`/home/MAYANK/E-coli-NGS-Variant-Analysis/`

and the data/output workspace:

`/home/MAYANK/NGS2/`

Depending on the logging configuration, logs may contain machine-specific paths. Review them before publishing.

## Log Management

Logs should be retained locally for debugging and reproducibility. The repository does not need every execution log committed indefinitely.

If logs are excluded using `.gitignore`, retain them in the local workspace and document how to locate them. If a particular log is published, ensure that it corresponds to the documented run and does not expose unnecessary personal or system information.

