#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pvacseq_env

snakemake --snakefile netCTLpan.snakefile -j 71 --keep-target-files --rerun-incomplete 
