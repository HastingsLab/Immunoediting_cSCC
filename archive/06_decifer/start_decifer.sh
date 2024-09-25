#!/bin/bash
#SBATCH --job-name=GATK
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=60gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate decifer

snakemake --snakefile decifer_pipeline.snakemake -j 300 --rerun-incomplete
