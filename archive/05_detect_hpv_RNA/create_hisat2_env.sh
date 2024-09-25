#!/bin/bash
#SBATCH --job-name=Mapping
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate hisat2_env

hisat2-build /xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/GRCh38_combined_PAVE_hpv.fa /xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/hisat-index/GRCh38_combined_PAVE_hpv

