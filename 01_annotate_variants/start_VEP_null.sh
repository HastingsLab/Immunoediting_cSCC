#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=24:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate vep_env

snakemake --snakefile VEP_null.snakefile -j 71 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=190gb --time=24:00:00"
