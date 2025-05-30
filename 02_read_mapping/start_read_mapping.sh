#!/bin/bash
#SBATCH --job-name=all_samples_map
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=168:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

snakemake --snakefile read_mapping.snakefile -j 156 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --time=48:00:00 --cpus-per-task={threads}"
