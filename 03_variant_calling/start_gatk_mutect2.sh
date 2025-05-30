#!/bin/bash
#SBATCH --job-name=all_samples_gatk
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=72:00:00
#SBATCH --partition=windfall

source activate cancergenomics

snakemake --snakefile gatk_mutect2.snakefile -j 80 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=windfall --time=24:00:00 --cpus-per-task={threads} --mem-per-cpu=41gb --constraint=hi_mem"
