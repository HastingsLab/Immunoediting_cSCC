#!/bin/bash
#SBATCH --job-name=CNVKit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate hatchet

python3 -m hatchet count-alleles -N /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam -T /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_1_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam -r /xdisk/khasting/knodele/references/1000genomes_GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa -c 100 -C 3000 -L Test_P1/*.vcf.gz -O P1normal.1bed -o P1tumor.1bed |& tee P1_bafs.log
