#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=10:00:00
#SBATCH --partition=windfall
#SBATCH -o /xdisk/khasting/knodele/Mayo_human_data/netMHCoutputs/%j.out # STDOUT

source activate vep_env

snakemake --snakefile netMHCpan_scrambled_alleles.snakefile -j 100 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=windfall --mem=500gb --time=06:00:00 -o /xdisk/khasting/knodele/Mayo_data/netMHCoutputs/%j.out"
