#!/bin/bash
#SBATCH --job-name=Create_config
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

python generate_config.py --fastq_path /xdisk/khasting/knodele/Mayo_human_data/fastq/ \
                          --sample_info ~/Immunoediting_Human_cSCC/03_detect_hpv/Mayo_metadata_normal_fastq_IDs.csv \
                          --ref_dir /xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/ \
                          --ref_basename GRCh38_combined_PAVE_hpv \
