# Immunoediting in Human Cutaneous Squamous Cell Carcinoma

**Last updated:** 9/25/2024

**Created by:** Elizabeth Borden

**Contact information:** knodele@arizona.edu

## Description

The goal of this analysis is to compare the neoantigen profiles of cSCC from immunocompetent and immunosuppressed individuals with the hypothesis that cSCC from immunosuppressed individuals will have a more immunogenic neoantigen profile. Since cSCC from immunosuppressed individuals have formed in the absense of immune surveillance, it is expected that there would be less selective pressure and therefore a more immunnogenic neoantigen profile. 

## 00_setup

Contains all conda environment .yml files used in the analyses **Needs to be updated**


## 01_annotate_variants

All somatic variants were identified using the methods described in the Genome_GPA v5.0.3 algorithm

VEP.snakefile

- Variant call obtained from the Mayo clinic contained all variants from Strelka and GATK Mutect2

- Selected variants called by the intersection of both Strelka and GATK Mutect2 and restricted to those that passed the standard GATK filters

- Performed VEP annotation

PVACseq.snakefile

- Generated peptides using PVACseq software

VEP_null and PVACseq_null

- Repeat the same process of variant annotation and peptide generation for in silico mutations generated for each patient

## 02_predict_binding

extract_hla.snakefile
- Extracts Polysolver-calculated HLA types for each patient

netMHCpan.snakefile
- Predicts netMHCpan binding and netMHCstab stability for each true patient mutation on true patient HLA alleles

netMHCpan_WT.snakefile
- Predicts netMHCpan binding for the corresponding wildtype pepdite for each true patient mutation on true patient HLA alleles

netMHCpan_scrambled_alleles.snakefile
- Predicts netMHCpan binding for each true patient mutation on random, non-patient HLA alleles
  
netMHCpan_null_mutations.snakefile
- Predicts netMHCpan binding for in silico mutations on true patient HLA alleles

netCTLpan.snakefile                 
- Predicts TAP transport potential and proteasomal cleavage for each true patient mutation

PRIME
- All code for predicting the PRIME scores for each neoantigen

## 03_copy_number

map.snakefile

- Maps all samples to reference genome to generate BAM files for use in the copy number calculation

preparePON.sh

- Creates a panel of normals for use in copy number identifiation

calculate_CN.sh

- Calculates copy number distributions relative to the panel of normals for each sample

CNVKit_adjustment.snakemake

- Creates the final output file for use in cancer cell fraction calculation

## 0_RNA_sample_purity

puree.python
- Code for predicting sample purity from RNAseq data

## 05 Cross-reactivity distance

luksza.snakefile
- Applies the models from Luksza et al (https://www.nature.com/articles/s41586-022-04735-9)

## 06_clustering_analysis

Cluster_analysis_determine_n_clusters.R
- Applies the code for determining the number of clusters by maximizing the gap statistic in the analysis of neonatigens enriched in the subclonal population

Cluster_analysis_create_heatmap.R
- Applies the code for plotting the final heatmap and all boxplots and violin plots incorporated in the final manuscript

## 07_growth_rate_simulations

Iterations of growth rate simulations

Growth_simulations.R
- Original simulation with absolute mutations, growth 1-2, ratio 0-1, and mutations 1-10x the total observed mutations

Growth_simulations_relative_mutations.R
- Changes from absolute to relative mutations,  growth 1-2, ratio 0-0.5 (restricted ratio to be more biologically reasonable)

Growth_simulations_relative_mutations_add_cell_number.R
- Relative mutations, but adds a cell number as an optimizable parameter

Growth_simulations_relative_mutations_restrict_coverage.R
- Relative mutations, but restricts mutations considered to those with a read coverage >10

Growth_simulations_relative_mutations_CN2.R
- Relative mutations, but restricts to mutations with a CN=2

All files starting with Compile_results, create a .csv file with the full results from the corresponding simulation file (assists with parallelization)

All files starting with "start" are sbatch scripts for submitting the jobs

Simulation results saved in previous results files except those used in the final manuscript which are saved in "final_results"

## 08_in_silico_mutation_annotation

/Enrichment results:
- Code for running the mRNA enrichment analysis on the in silico mutational profiles

/Proportion binding: 
- Code for calculating the proportion of binding mutations for each iteration
