#!/bin/bash
#SBATCH --job-name=all_samples_strelka
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

snakemake --snakefile strelka_downsampled.snakefile -j 80 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --time=48:00:00 --cpus-per-task={threads}"
