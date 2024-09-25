#!/bin/bash
#SBATCH --job-name=Mapping
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

snakemake --snakefile prepare_references.snakefile -j 50 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --mem=30gb -t 06:00:00"
