#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate star_env

#snakemake --snakefile salmon_gencode.snakefile -j 20
snakemake --snakefile star.snakefile -j 100 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --time=48:00:00 --ntasks=40 --mem=900gb"
