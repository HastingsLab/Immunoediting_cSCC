#!/bin/bash
#SBATCH --job-name=Mapping
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cancergenomics

~/programs/gatk-4.1.8.1/gatk --java-options "-Xmx6500m" CreateReadCountPanelOfNormals \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_065-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
	-I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
	-I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_36_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_39C_DNA_combined.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_42C__octothorp_2.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_56_extra.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_53C_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_060-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_303-_T2a_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_098-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_311-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_102-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_5_DNA_combined.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_323-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_106-T2a-1c_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_321-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_110-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_307-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_152-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_305-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_154-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_156-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_158-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_9_DNA_combined.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_160-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_162-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-364-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_164-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_166-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_168-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_170-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_172-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_202-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_10C_DNA_combined.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_204-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_206-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_62-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_66-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_069-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_301-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_70-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_74-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_073-T2b-1c_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-374-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_13__octothorp_2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_078-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_367-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_082-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_381-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_086-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-360-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_090-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-350-T3_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_094-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_317-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_57__octothorp_2.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_58_DNA_combined.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_19__octothorp_2.GRCh38_combined_PAVE_hpv.hdf5 \
        -I /xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_30C_DNA.GRCh38_combined_PAVE_hpv.hdf5 \
	--minimum-interval-median-percentile 5.0 \
	-O /xdisk/khasting/knodele/Mayo_human_data/processed_bams/Mayo_PON.hdf5
