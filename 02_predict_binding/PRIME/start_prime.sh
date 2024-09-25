#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=42
#SBATCH --nodes=10
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate PRIME_env

snakemake --snakefile prime.snakefile -j 42  
