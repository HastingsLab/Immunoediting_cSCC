#!/bin/bash
#SBATCH --job-name=Mapping
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

snakemake --snakefile map.snakefile -j 50 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --mem=30gb -t 12:00:00"
