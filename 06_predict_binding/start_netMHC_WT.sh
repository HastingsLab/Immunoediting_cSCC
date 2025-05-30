#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting
#SBATCH -o /xdisk/khasting/knodele/Mayo_data/netMHCoutputs/WT/slurm%j.out

source activate cancergenomics


snakemake --latency-wait 90 --snakefile netMHCpan_WT.snakefile -j 80 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting --mem=50gb --ntasks=10 --time=48:00:00 -o /xdisk/khasting/knodele/Mayo_data/netMHCoutputs/WT/slurm%j.out"
