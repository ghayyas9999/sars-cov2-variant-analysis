# SARS-CoV-2 Amplicon Sequencing Variant Analysis

A reproducible bioinformatics workflow for analyzing SARS-CoV-2 amplicon sequencing data, from raw-read quality control through variant calling and downstream analysis in R.

## Overview

This project analyzes five publicly available paired-end SARS-CoV-2 amplicon sequencing datasets obtained from the SRA/ENA archives.

The workflow combines command-line bioinformatics tools, the `nf-core/viralrecon` pipeline, and R-based downstream analysis to identify and summarize SARS-CoV-2 genetic variants.

### Analysis Workflow

```text
SRA / ENA
    ↓
Raw Read Download
    ↓
FastQC + MultiQC
    ↓
Sample Sheet Generation
    ↓
nf-core/viralrecon
    ↓
Variant Calling with iVar
    ↓
Merged Variant Table
    ↓
R / tidyverse / ggplot2
    ↓
Variant and Read-Depth Analysis
```

## Objectives

- Download publicly available SARS-CoV-2 sequencing datasets
- Perform raw-read quality control
- Generate a samplesheet for downstream processing
- Perform SARS-CoV-2 variant calling using `nf-core/viralrecon`
- Summarize variants across samples and genomic regions
- Analyze read-depth (DP) distributions
- Generate visualizations using R and `ggplot2`
- Maintain a reproducible analysis structure using scripts and environment management

## Dataset

Five paired-end SARS-CoV-2 amplicon sequencing datasets were used.

| Accession | Source |
|---|---|
| ERR5181310 | ENA |
| ERR5405022 | ENA |
| ERR5556343 | ENA |
| ERR5743893 | ENA |
| SRR13500958 | SRA |

The datasets were obtained from public sequencing archives and are not stored directly in this repository.

## Pipeline

### 1. Raw Read Download

Reads were downloaded from SRA/ENA using the SRA Toolkit:

- `sra-tools`
- `prefetch`
- `fasterq-dump`

### 2. Quality Control

Raw sequencing reads were evaluated using:

- FastQC
- MultiQC

### 3. Sample Sheet Generation

A samplesheet was generated for use with the `nf-core/viralrecon` workflow.

### 4. Variant Calling

Variant calling was performed using:

- `nf-core/viralrecon` 2.6.0
- Nextflow
- Docker
- ARTIC v3 primer scheme
- iVar variant caller
- Illumina sequencing platform
- SARS-CoV-2 reference genome `MN908947.3`

### 5. Downstream Analysis

The merged variant table was analyzed in R using:

- tidyverse
- dplyr
- readr
- tibble
- ggplot2

The downstream analysis includes:

- Per-sample variant counts
- Per-gene variant counts
- Read-depth (DP) distributions
- DP comparisons across samples
- Variant distribution across genomic regions

## Results

### Variant Calls

A total of **153 variants** were identified across the five analyzed samples.

| Sample | Variants Called |
|---|---:|
| ERR5181310 | 33 |
| ERR5405022 | 36 |
| ERR5556343 | 35 |
| ERR5743893 | 28 |
| SRR13500958 | 21 |
| **Total** | **153** |

### Read Depth

Across all 153 called variants:

- **Minimum DP:** 38×
- **Mean DP:** ~2,635×
- **Maximum DP:** 41,836×

These values describe the read-depth distribution of the called variants and provide a basic measure of sequencing coverage supporting the variant calls.

For detailed results and generated outputs, see [`results/README.md`](results/README.md).

## Repository Structure

```text
sars-cov2-variant-analysis/
│
├── data/
│   └── samplesheet.csv
│
├── env/
│
├── results/
│   └── README.md
│
├── scripts/
│   ├── 01_download_sra.sh
│   ├── 02_run_fastqc.sh
│   ├── 03_run_viralrecon.sh
│   └── 04_variant_analysis.R
│
├── samples.txt
├── .gitignore
├── LICENSE
├── NGS analysis.Rproj
├── README.md
└── renv.lock
```

Raw FASTQ files and large pipeline outputs such as BAMs, VCFs, MultiQC reports, and the Nextflow `work/` directory are excluded from version control because they are large and can be reproduced using the provided workflow scripts.

## Tools and Versions

| Tool | Purpose |
|---|---|
| SRA Toolkit 3.4.1 | Download sequencing reads |
| FastQC | Raw-read quality control |
| MultiQC | QC report aggregation |
| Nextflow | Workflow execution |
| nf-core/viralrecon 2.6.0 | Viral genome analysis and variant calling |
| Docker | Containerized pipeline execution |
| iVar | Variant calling |
| R | Downstream analysis |
| tidyverse | Data manipulation |
| ggplot2 | Data visualization |

## Reproducibility

The analysis is organized as a sequence of executable scripts:

```text
01_download_sra.sh
        ↓
02_run_fastqc.sh
        ↓
03_run_viralrecon.sh
        ↓
04_variant_analysis.R
```

### 1. Download Sequencing Reads

```bash
conda create -n MOOC -c conda-forge -c bioconda sra-tools fastqc multiqc -y
conda activate MOOC

./scripts/01_download_sra.sh
```

### 2. Quality Control and Samplesheet Generation

```bash
./scripts/02_run_fastqc.sh
```

### 3. Run Variant Analysis

```bash
conda create -n nextflow -c bioconda nextflow -y
conda activate nextflow

./scripts/03_run_viralrecon.sh
```

### 4. Perform Downstream R Analysis

```bash
Rscript scripts/04_variant_analysis.R
```

## Reproducible R Environment

The repository includes `renv.lock` to record the R package environment used for downstream analysis.

This helps document the software environment and supports reproducibility of the R-based analysis.

## Limitations

- Only five publicly available SARS-CoV-2 datasets were analyzed.
- The analysis is based on publicly available sequencing data and therefore depends on the quality and characteristics of those datasets.
- Large raw sequencing files and intermediate pipeline outputs are not stored in the repository.
- The results represent this specific dataset selection and should not be interpreted as a comprehensive analysis of global SARS-CoV-2 variation.

## Future Improvements

Potential extensions of this project include:

- Analysis of a larger number of SARS-CoV-2 samples
- Variant annotation and functional interpretation
- Comparison of variants across geographic or temporal groups
- Phylogenetic analysis
- Integration with public SARS-CoV-2 lineage information
- Expanded visualization and statistical analysis

## License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE) for details.
