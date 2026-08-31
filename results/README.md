# Results

Raw pipeline outputs (BAMs, consensus FASTAs, VCFs, MultiQC HTML, Nextflow
`work/` directory) are not checked into this repo because of their size and
because they're fully reproducible from `scripts/03_run_viralrecon.sh`.

After running the pipeline, the key files you'll get are:

- `results/viralrecon/variants/ivar/*.vcf.gz` — per-sample variant calls
- `results/viralrecon/variants/ivar/variants_long_table.csv` — merged, annotated
  variant table across all samples (input to `scripts/04_variant_analysis.R`)
- `results/viralrecon/multiqc/multiqc_report.html` — QC/pipeline summary report

## Summary of this run

| Sample | Variants called |
|---|---|
| ERR5181310 | 33 |
| ERR5405022 | 36 |
| ERR5556343 | 35 |
| ERR5743893 | 28 |
| SRR13500958 | 21 |

Read depth (DP) across all 153 variants: min 38, mean 2635, max 41836.
