#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=1:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

#source activate cancergenomics
source activate vep_env

snakemake --snakefile VEP_downsampled.snakefile -j 80 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=500gb --time=1:00:00"
