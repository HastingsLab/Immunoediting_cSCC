#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=42:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate new_variant_calling

snakemake --snakefile variant_expression_quantification.snakefile -j 300 --rerun-incomplete
