#!/bin/bash
#SBATCH --job-name=Mapping
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

snakemake --snakefile copy_ratio_allelic_segments.snakemake -j 50 --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --mem=30gb -t 96:00:00"
