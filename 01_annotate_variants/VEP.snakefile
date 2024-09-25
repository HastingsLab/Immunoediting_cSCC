# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P10", "P11", "P12", "P13", "P14", "P15", "P16", "P17", "P18", "P19", "P1", "P20", "P21", "P22", "P23", "P24", "P25", "P26", "P27", "P28", "P29",
"P2A", "P2B", "P30", "P31", "P32", "P33", "P34", "P35", "P36", "P37", "P38", "P39A", "P39B", "P3", "P40", "P41", "P42", "P43", "P44", "P45", "P46", "P47", "P48", "P49", "P4",
"P50", "P51", "P52", "P52", "P53", "P54", "P55", "P56", "P57", "P58", "P59", "P5", "P6", "P7", "P8", "P9"]
#samples = ["P10"]

configfile: "sample_id_config.json"

#Paths
vcf_path = "/xdisk/khasting/knodele/Mayo_human_data/variant_calls/"
vep_path = "/xdisk/khasting/knodele/Mayo_human_data/vep/"

rule all:
    input:
        expand(os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.vcf"), sample=samples, vep_path=vep_path), # run VEP
        expand(os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.maf"), sample=samples, vep_path=vep_path) # Change header

#rule gunzip_vcf:
#	input: 
#		os.path.join(vcf_path, "{sample}.somaticvariants.vcf.gz")
#	output:
#		os.path.join(vcf_path, "{sample}.somaticvariants.vcf")
#	shell:
#		"""
#		gunzip {input}
#		"""

#rule subset_vep:
#        input:
#                os.path.join(vcf_path, "{sample}.somaticvariants.vcf")
#        output:
#                os.path.join(vcf_path, "{sample}.somaticvariants_filtered.vcf")
#        shell:
#                """
#                bcftools view -i "%FILTER='PASS' & set='Intersection'" {input} -o {output}
#                """

## Commented out because the input files were generated separately for P2A and P2B and P39A and P39B and then added back in here which is messing up job submission

rule run_vep:
	input:
		os.path.join(vcf_path, "{sample}.somaticvariants_filtered.vcf")
	output:
		os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.vcf")
	shell:
		"""
		vep -i {input} --format vcf --assembly GRCh38 --cache -cache_version 109 --dir_cache /xdisk/khasting/knodele/vep_ref --offline --vcf -o {output} --force_overwrite --plugin Wildtype --symbol --terms SO --plugin Downstream --plugin Frameshift
		""" 


rule maf: 
	input: 
		os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.vcf")
	output: 
		os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.maf")
	params: 
		sample = lambda wildcards: config[wildcards.sample]["id"]
	shell: 
		"""
		perl ~/programs/mskcc-vcf2maf-754d68a/vcf2maf.pl --inhibit-vep --input-vcf {input} --output-maf {output} --ref-fasta /xdisk/khasting/knodele/vep_ref/homo_sapiens/109_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --vep-path ~/miniconda3/envs/vep_env/bin --ncbi-build GRCh38 --tumor-id {params.sample}
		"""

