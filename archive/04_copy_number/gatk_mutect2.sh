#!/bin/bash
#SBATCH --job-name=GATK
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate new_variant_calling

snakemake --snakefile gatk_mutect2.snakemake -j 100 --cores 100 --rerun-incomplete

#snakemake --snakefile gatk_mutect2.snakemake -j 300 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --mem=30gb -t 96:00:00"
