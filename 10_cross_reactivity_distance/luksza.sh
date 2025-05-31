#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --time=1:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pvacseq_env

snakemake --snakefile luksza.snakefile -j 70 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --time=1:00:00"
