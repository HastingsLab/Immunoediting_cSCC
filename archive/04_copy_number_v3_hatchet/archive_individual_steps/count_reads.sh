#!/bin/bash
#SBATCH --job-name=CNVKit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate hatchet

python3 -m hatchet count-reads -N /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam -T /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_1_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam -b P1tumor.1bed -O read_counts/normal.1bed -O read_counts -V hg38 |& tee read_counts_bins.log

