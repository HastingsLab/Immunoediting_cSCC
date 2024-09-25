#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=60gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pvacseq_env

snakemake --snakefile luksza.snakefile -j 1 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=50gb --time=2:00:00"
