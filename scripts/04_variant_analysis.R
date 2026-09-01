# 04_variant_analysis.R
#
# Downstream exploration of the ivar variant calls produced by
# nf-core/viralrecon (results/viralrecon/variants/ivar/variants_long_table.csv).
#
# Requirements: R with the tidyverse package (readr, dplyr, ggplot2, tibble).

library(tidyverse)

# ---- Load ------------------------------------------------------------
variants <- read.csv("results/viralrecon/variants/ivar/variants_long_table.csv")
var_tb <- as_tibble(variants)

str(var_tb)
summary(var_tb)

# ---- Basic exploration -------------------------------------------------
# Variants per sample
var_tb %>% count(SAMPLE, sort = TRUE)

# Variants per sample and gene
var_tb %>% count(SAMPLE, GENE, sort = TRUE) %>% head()

# Depth (DP) summary across all variants
summary(var_tb$DP)
max(var_tb$DP)
min(var_tb$DP)
mean(var_tb$DP)

# Per-sample DP range
var_tb %>% group_by(SAMPLE) %>% summarize(max_DP = max(DP), min_DP = min(DP))

# ---- Filtering examples --------------------------------------------------
# High-confidence variants (DP >= 500) for a given sample
var_tb %>%
  filter(SAMPLE == "SRR13500958", DP >= 500) %>%
  select(CHROM, POS, REF, ALT, DP)

# Very high depth variants (DP >= 1000)
var_tb %>%
  filter(SAMPLE == "SRR13500958", DP >= 1000) %>%
  select(CHROM, POS, REF, ALT, DP)

# ---- Transform -----------------------------------------------------------
var_tb_log <- var_tb %>% mutate(DP_log2 = log2(DP))

# ---- Plots -----------------------------------------------------------
# DP per sample, boxplot
ggplot(var_tb, aes(x = SAMPLE, y = DP, fill = SAMPLE)) +
  geom_boxplot() +
  ylim(0, 10000) +
  scale_fill_manual(values = c("#cb6015", "#e1ad01", "#6d0016", "#808000", "#4e3524"))

# DP per sample, log10 scale
ggplot(var_tb, aes(x = SAMPLE, y = DP)) +
  geom_point() +
  scale_y_log10()

# DP distribution across the SARS-CoV-2 reference, faceted by sample
p_DP_CHROM <- ggplot(var_tb, aes(x = CHROM, y = DP, fill = SAMPLE)) +
  ylim(0, 10000) +
  scale_fill_brewer(palette = "RdYlBu") +
  labs(title = "Read Depth per Sample") +
  theme(legend.position = "bottom")

p_DP_CHROM +
  geom_violin(trim = FALSE) +
  facet_grid(. ~ SAMPLE) +
  geom_boxplot(width = 0.1)
