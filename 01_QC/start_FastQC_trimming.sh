#!/bin/bash
#SBATCH --job-name=all_samples_QC
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=14
#SBATCH --time=48:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

snakemake --snakefile FastQC_trimming.snakefile -j 100 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --time=48:00:00"
