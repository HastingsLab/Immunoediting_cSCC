#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=190gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate split_env

snakemake --snakefile split_variants.snakefile -j 71 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=3000gb --time=96:00:00"
