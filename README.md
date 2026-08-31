# SARS-CoV-2 Amplicon Sequencing Variant Analysis

Variant-calling pipeline and downstream analysis for five SARS-CoV-2
paired-end amplicon sequencing datasets pulled from public SRA/ENA archives,
processed with [nf-core/viralrecon](https://nf-co.re/viralrecon) and explored
in R.

## Samples

| Accession | Source |
|---|---|
| ERR5181310 | ENA |
| ERR5405022 | ENA |
| ERR5556343 | ENA |
| ERR5743893 | ENA |
| SRR13500958 | SRA |

## Pipeline overview

1. **Download raw reads** from SRA/ENA with `sra-tools` (`prefetch` +
   `fasterq-dump`).
2. **Quality control** with FastQC, summarized with MultiQC.
3. **Build the samplesheet** with nf-core's `fastq_dir_to_samplesheet.py`.
4. **Variant calling** with `nf-core/viralrecon` (amplicon protocol, ARTIC
   v3 primer scheme, Illumina platform, `ivar` caller) against the
   Wuhan-Hu-1 reference genome (`MN908947.3`), run via Docker.
5. **Downstream analysis** of the merged variant table in R
   (`tidyverse`/`ggplot2`): per-sample and per-gene variant counts, read-depth
   (DP) distributions, and DP visualizations across samples and chromosome
   regions.

## Tools & versions

- `sra-tools` 3.4.1 (download reads — older 2.9.x fails NCBI's TLS handshake)
- `fastqc` / `multiqc`
- `nextflow` (pipeline run pinned to `nf-core/viralrecon` release `2.6.0`)
- Docker (container profile for pipeline execution)
- R with `tidyverse` (`dplyr`, `readr`, `tibble`, `ggplot2`)

## Repository structure

```
.
├── data/
│   └── samplesheet.csv       # sample -> FASTQ file mapping (paths only; reads are not checked in)
├── samples.txt                # SRA/ENA accessions to download
├── scripts/
│   ├── 01_download_sra.sh     # SRA download -> data/*.fastq.gz
│   ├── 02_run_fastqc.sh       # FastQC + MultiQC + samplesheet generation
│   ├── 03_run_viralrecon.sh   # nf-core/viralrecon variant-calling run
│   └── 04_variant_analysis.R  # downstream analysis of the variant table
└── results/
    └── README.md              # what the pipeline outputs and a summary of this run
```

Raw reads and full pipeline outputs (BAMs, VCFs, the Nextflow `work/`
directory, MultiQC HTML) are excluded via `.gitignore` since they're large
and fully reproducible from the scripts above.

## Reproducing this analysis

```bash
# 1. Download reads
conda create -n MOOC -c conda-forge -c bioconda sra-tools fastqc multiqc -y
conda activate MOOC
./scripts/01_download_sra.sh

# 2. QC + samplesheet
./scripts/02_run_fastqc.sh

# 3. Variant calling (requires Nextflow + Docker)
conda create -n nextflow -c bioconda nextflow -y
conda activate nextflow
./scripts/03_run_viralrecon.sh

# 4. Downstream analysis in R
Rscript scripts/04_variant_analysis.R
```

## Results summary

Across the 5 samples, 153 variants were called relative to `MN908947.3`.
Variant counts per sample ranged from 21 (SRR13500958) to 36 (ERR5405022);
read depth (DP) ranged from 38x to 41,836x (mean ~2,635x). See
`results/README.md` for the full breakdown and
`scripts/04_variant_analysis.R` for the plots used to visualize DP
distributions across samples and genomic regions.

## License

MIT — see [LICENSE](LICENSE).
