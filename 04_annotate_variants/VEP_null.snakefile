# Setting up filesnames here:
from os.path import join
import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

#Sample IDs
samples = ["P001","P055","P13","P18","P26","P34","P3","P54","P7","P002","P062","P14","P19","P27","P35","P40","P55","P8",
"P004","P083","P164","P20","P28","P36","P41","P57","P9","P010","P113","P169","P22","P2A","P37","P47","P58","P015","P11",
"P17","P23","P2B","P38", "P48", "P59","P017","P133","P182","P24","P30","P39A","P49","P5","P050","P138","P183","P25","P33",
"P39B","P4","P6"]

#Paths
vcf_path = "/xdisk/khasting/knodele/Mayo_data/In_silico_muts/"
vep_path = "/xdisk/khasting/knodele/Mayo_data/In_silico_muts/"

rule all:
    input:
        expand(os.path.join(vep_path, "{sample}_fake_mutations_vep.vcf"), sample=samples, vep_path=vep_path), # run VEP
        expand(os.path.join(vep_path, "{sample}_fake_mutations_vep.maf"), sample=samples, vep_path=vep_path) # Change header

rule sort:
	input:
 		os.path.join(vcf_path, "{sample}_fake_mutations.txt")
	output:
		os.path.join(vcf_path, "{sample}_fake_mutations.vcf")
	shell:
		"""
		sort -k1,1n -k2,2n {input} | sed 's/^/chr/g' | awk '{{print $1"\t"$2"\t.\t"$3"\t"$4}}' > {output}
		"""

rule run_vep:
	input:
		os.path.join(vcf_path, "{sample}_fake_mutations.vcf")
	output:
		os.path.join(vep_path, "{sample}_fake_mutations_vep.vcf")
	shell:
		"""
		/xdisk/khasting/knodele/programs/ensembl-vep/vep -i {input} --format vcf --assembly GRCh38 --cache -cache_version 109 --dir_cache /xdisk/khasting/knodele/vep_ref --offline --vcf -o {output} --force_overwrite --plugin Wildtype --symbol --terms SO --plugin Downstream --plugin Frameshift
		""" 


rule maf: 
	input: 
		os.path.join(vep_path, "{sample}_fake_mutations_vep.vcf")
	output: 
		os.path.join(vep_path, "{sample}_fake_mutations_vep.maf")
	params: 
		sample = lambda wildcards: config[wildcards.sample]["tumor"]
	shell: 
		"""
		perl /xdisk/khasting/knodele/programs/mskcc-vcf2maf-754d68a/vcf2maf.pl --inhibit-vep --input-vcf {input} --output-maf {output} --ref-fasta /xdisk/khasting/knodele/vep_ref/homo_sapiens/109_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --vep-path ~/miniconda3/envs/vep_env/bin --ncbi-build GRCh38 --tumor-id {params.sample}
		"""

