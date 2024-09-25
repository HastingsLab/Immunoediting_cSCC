#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=2:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate vcf_to_ssm

snakemake --snakefile prep_ssm_file.snakemake -j 300 --rerun-incomplete
