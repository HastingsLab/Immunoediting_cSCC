# Setting up filesnames here:
from os.path import join
import os


#Paths
vcf_path = "/xdisk/khasting/knodele/Mayo_human_data/variant_calls/"

rule all:
	input:
		expand(os.path.join(vcf_path, "P2A.somaticvariants_filtered.vcf"), vcf_path=vcf_path), # Split file 2
		expand(os.path.join(vcf_path, "P2A.somaticvariants.vcf"), vcf_path=vcf_path),
		expand(os.path.join(vcf_path, "P2B.somaticvariants_filtered.vcf"), vcf_path=vcf_path),
		expand(os.path.join(vcf_path, "P2B.somaticvariants.vcf"), vcf_path=vcf_path),
		expand(os.path.join(vcf_path, "P39B.somaticvariants_filtered.vcf"), vcf_path=vcf_path), # Split file 39
		expand(os.path.join(vcf_path, "P39B.somaticvariants.vcf"), vcf_path=vcf_path),
		expand(os.path.join(vcf_path, "P39A.somaticvariants_filtered.vcf"), vcf_path=vcf_path),
		expand(os.path.join(vcf_path, "P39A.somaticvariants.vcf"), vcf_path=vcf_path)

rule subset_2A:
	input:
		os.path.join(vcf_path, "P2.somaticvariants_filtered.vcf")
	output:
		os.path.join(vcf_path, "P2A.somaticvariants_filtered.vcf")
	shell:
		"""
		bcftools view -s "s_CSCC_4_DNA,s_CSCC_5_DNA_combined" {input} --min-ac=1 -o {output}
		"""

rule subset_2A_unfiltered:
	input:
		os.path.join(vcf_path, "P2.somaticvariants.vcf")
	output:
		os.path.join(vcf_path, "P2A.somaticvariants.vcf")
	shell:
		"""
		bcftools view -s "s_CSCC_4_DNA,s_CSCC_5_DNA_combined" {input} --min-ac=1 -o {output}
		"""

rule subset_2B:
	input:
		os.path.join(vcf_path, "P2.somaticvariants_filtered.vcf")
	output:
		os.path.join(vcf_path, "P2B.somaticvariants_filtered.vcf")
	shell:
		"""
		bcftools view -s "s_CSCC_6_DNA,s_CSCC_5_DNA_combined" {input} --min-ac=1 -o {output}
		"""

rule subset_2B_unfiltered:
	input:
		os.path.join(vcf_path, "P2.somaticvariants.vcf")
	output:
		os.path.join(vcf_path, "P2B.somaticvariants.vcf")
	shell:
		"""
		bcftools view -s "s_CSCC_6_DNA,s_CSCC_5_DNA_combined" {input} --min-ac=1 -o {output}
		"""

rule subset_39B:
	input:
		os.path.join(vcf_path, "P39.somaticvariants_filtered.vcf")
	output:
		os.path.join(vcf_path, "P39B.somaticvariants_filtered.vcf")
	shell:
		"""
		bcftools view -s "s_201-T2b_B2_DNA,s_202-T2b_B2_DNA" {input} --min-ac=1 -o {output}
		"""

rule subset_39B_unfiltered:
	input:
		os.path.join(vcf_path, "P39.somaticvariants.vcf")
	output:
		os.path.join(vcf_path, "P39B.somaticvariants.vcf")
	shell:
		"""
		bcftools view -s "s_201-T2b_B2_DNA,s_202-T2b_B2_DNA" {input} --min-ac=1 -o {output}
		"""

rule subset_39A:
	input:
		os.path.join(vcf_path, "P39.somaticvariants_filtered.vcf")
	output:
		os.path.join(vcf_path, "P39A.somaticvariants_filtered.vcf")
	shell:
		"""
		bcftools view -s "s_200-T2b_B2_DNA,s_202-T2b_B2_DNA" {input} --min-ac=1 -o {output}
		"""

rule subset_39A_unfiltered:
	input:
		os.path.join(vcf_path, "P39.somaticvariants.vcf")
	output:
		os.path.join(vcf_path, "P39A.somaticvariants.vcf")
	shell:
		"""
		bcftools view -s "s_200-T2b_B2_DNA,s_202-T2b_B2_DNA" {input} --min-ac=1 -o {output}
		"""
