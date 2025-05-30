#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=1:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pvacseq_env
#source activate cancergenomics
#source activate vep_env

snakemake --snakefile PVACseq.snakefile -j 71 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --ntasks=10 --mem=50gb --time=1:00:00"
