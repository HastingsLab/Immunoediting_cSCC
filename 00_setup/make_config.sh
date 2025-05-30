#!/bin/bash
#SBATCH --job-name=Create_config
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

python generate_config.py --fastq_path /xdisk/khasting/knodele/Mayo_human_data/fastq/ \
                          --sample_info Metadata_Mayo_for_config_generation.csv \
                          --ref_dir /xdisk/khasting/knodele/references/1000genomes_GRCh38_reference_genome \
                          --ref_basename GRCh38_full_analysis_set_plus_decoy_hla \
