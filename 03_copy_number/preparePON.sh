#!/bin/bash
#SBATCH --job-name=CNVKit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate cnvkit

cnvkit.py batch \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_1_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_8_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_10T_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_12_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_14_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_16_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_18_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_29_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_35_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_39T_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_41_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_48_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_52_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_061-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-302_-_T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_097-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_310-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_101-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_322-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_105-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_320-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_306-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_151-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_304-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_153-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_155-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_157-T2a_2_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_159-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_161-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_064-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-363-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_163-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_165-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_167-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_169-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_171-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_200-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_203-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_205-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_61-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_65-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_068-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_300-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_69-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_73-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_072-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-373-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_077-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_366-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_081-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_380-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_085-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-359-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_089-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-349-T3_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_093-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_316-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_6_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_201-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	--normal \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_5_DNA_combined.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_9_DNA_combined.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_10C_DNA_combined.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_13__octothorp_2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_57__octothorp_2.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_58_DNA_combined.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_19__octothorp_2.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_30C_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_36_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_39C_DNA_combined.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_42C__octothorp_2.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_56_extra.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_53C_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_060-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_303-_T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_098-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_311-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_102-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_323-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_106-T2a-1c_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_321-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_110-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_307-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_152-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_305-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_154-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_156-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_158-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_160-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_162-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_065-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-364-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_164-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_166-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_168-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_170-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_172-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_202-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_204-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_206-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_62-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_66-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_069-T2b_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_301-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_70-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_74-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_073-T2b-1c_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-374-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_078-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_367-T2a_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_082-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_381-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_086-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-360-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_090-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC-350-T3_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_094-T2a_B2_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	/xdisk/khasting/knodele/Mayo_human_data/processed_bams/s_CSCC_317-T2b_B4_DNA.GRCh38_combined_PAVE_hpv.sorted.mkdup.bam \
	--targets hg38_Twist_ILMN_Exome_2.0_Plus_Panel_annotated.BED --fasta /xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/GRCh38_combined_PAVE_hpv.fa \
	--output-reference Mayo_combined_reference.cnn --output-dir /xdisk/khasting/knodele/Mayo_human_data/CNVKit_results/Mayo_combined_reference
