#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=24:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pvacseq_env

snakemake --snakefile PVACseq_null.snakefile -j 100 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --nodes=1 --ntasks=1 --mem=30gb --account=khasting --time=24:00:00"
