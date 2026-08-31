#!/usr/bin/env bash
# 01_download_sra.sh
# Downloads paired-end FASTQ reads for each SRA/ENA accession in samples.txt
# using sra-tools (prefetch + fasterq-dump), then compresses and moves them
# into data/ in the layout expected by samplesheet.csv.
#
# Requirements: conda env with sra-tools >= 3.0 (older 2.9.x builds hit TLS
# certificate errors against NCBI and fail silently on split-files).
#
# Usage: ./01_download_sra.sh

set -euo pipefail

SAMPLES_FILE="samples.txt"
OUTDIR="data"

mkdir -p "$OUTDIR"

while read -r accession; do
  [ -z "$accession" ] && continue
  echo ">>> Downloading $accession"
  prefetch "$accession"
  fasterq-dump "$accession" --split-files -O "$OUTDIR"
  gzip -f "$OUTDIR/${accession}_1.fastq" "$OUTDIR/${accession}_2.fastq"
done < "$SAMPLES_FILE"

echo "Done. Reads are in $OUTDIR/"
