#!/bin/bash
#SBATCH --job-name=GATK
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate hatchet

export HATCHET_COMPUTE_CN_SOLVER=cbc

snakemake --snakefile hatchet_pipeline_combined.snakemake -j 300 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --mem=30gb -t 3:00:00"
