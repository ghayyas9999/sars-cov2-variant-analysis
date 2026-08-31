#!/usr/bin/env bash
# 03_run_viralrecon.sh
# Runs the nf-core/viralrecon pipeline (amplicon protocol, ARTIC v3 primers)
# against the Wuhan-Hu-1 reference (MN908947.3) using Illumina paired-end
# reads, producing ivar-called variants.
#
# Requirements: Nextflow (tested with the nf-core/viralrecon 2.6.0 release)
# and Docker, with the docker daemon running.
#
# Usage: ./03_run_viralrecon.sh

set -euo pipefail

nextflow run nf-core/viralrecon -r 2.6.0 -profile docker \
  --max_memory '12.GB' --max_cpus 4 \
  --input data/samplesheet.csv \
  --outdir results/viralrecon \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version 3 \
  --skip_kraken2 \
  --skip_assembly \
  --skip_pangolin \
  --skip_nextclade \
  --skip_asciigenome \
  --platform illumina \
  -resume

echo "Pipeline finished. Variant calls: results/viralrecon/variants/ivar/"
echo "MultiQC summary: results/viralrecon/multiqc/multiqc_report.html"
