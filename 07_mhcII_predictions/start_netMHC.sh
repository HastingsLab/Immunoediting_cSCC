#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

snakemake --snakefile netMHCpan.snakefile -j 200 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=60gb --ntasks=10 --time=96:00:00 -o /xdisk/khasting/knodele/Mayo_data/netMHCoutputs/MT_classII/slurm%j.out"
