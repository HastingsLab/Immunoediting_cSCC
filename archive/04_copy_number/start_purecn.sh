#!/bin/bash
#SBATCH --job-name=PureCN_gatk
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=6000gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pureCN_env

snakemake --snakefile purecn_pipeline.snakemake -j 300 --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --mem=30gb -t 3:00:00"
