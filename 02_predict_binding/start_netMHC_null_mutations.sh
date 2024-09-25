#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=168:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate pvacseq_env

snakemake --snakefile netMHCpan_null_mutations.snakefile -j 71 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --ntasks=1 --nodes=1 --mem=30gb --time=168:00:00 -o /xdisk/khasting/knodele/Mayo_human_data/netMHCoutputs/%j.out"
