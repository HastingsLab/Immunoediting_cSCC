#!/bin/bash
#SBATCH --job-name=PureCN
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=6000gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

#source activate cnvkit
source activate pureCN_env

snakemake --snakefile purecn_pipeline.snakemake -j 300 --rerun-incomplete
