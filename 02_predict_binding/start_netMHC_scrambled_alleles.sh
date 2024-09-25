#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting
#SBATCH -o /xdisk/khasting/knodele/Mayo_human_data/netMHCoutputs/%j.out # STDOUT

source activate vep_env

snakemake --snakefile netMHCpan_scrambled_alleles.snakefile -j 50 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=500gb --time=40:00:00 -o /xdisk/khasting/knodele/Mayo_human_data/netMHCoutputs/%j.out"
