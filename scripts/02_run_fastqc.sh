#!/usr/bin/env bash
# 02_run_fastqc.sh
# Runs FastQC on all raw reads, summarizes with MultiQC, and generates the
# nf-core/viralrecon samplesheet from the data/ directory.
#
# Requirements: conda env with fastqc, multiqc; nf-core's
# fastq_dir_to_samplesheet.py helper script.
#
# Usage: ./02_run_fastqc.sh

set -euo pipefail

mkdir -p QC_Reports
fastqc data/*.fastq.gz --outdir QC_Reports
multiqc QC_Reports --outdir QC_Reports

# Regenerate the samplesheet straight from the reads in data/
if [ ! -f fastq_dir_to_samplesheet.py ]; then
  wget -q https://raw.githubusercontent.com/nf-core/viralrecon/master/bin/fastq_dir_to_samplesheet.py
fi
python3 fastq_dir_to_samplesheet.py data data/samplesheet.csv -r1 _1.fastq.gz -r2 _2.fastq.gz

echo "QC reports in QC_Reports/, samplesheet written to data/samplesheet.csv"
