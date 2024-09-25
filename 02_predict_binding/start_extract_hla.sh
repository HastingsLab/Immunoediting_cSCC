#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pvacseq_env

snakemake --snakefile extract_hla.snakefile -j 71 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=50gb --time=96:00:00"
