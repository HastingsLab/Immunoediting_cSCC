#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=24:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pairtree

snakemake --snakefile pairtree.snakemake -j 300 --rerun-incomplete
