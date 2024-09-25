# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P48","P47","P54","P58","P17","P19","P23","P25","P27","P28","P30","P34","P35","P36","P37",
"P38","P39A","P39B","P40","P41","P4","P5","P6","P7","P8","P9","P26","P24","P18","P59","P22","P20","P57",
"P55","P33","P49","P11","P13","P2A","P14","P2B","P3"]
#samples = ["P10"]

configfile: "sample_id_config.json"

#Paths
vcf_path = "/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/"
vep_path = "/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/"

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
		vep -i {input} --format vcf --assembly GRCh38 --cache -cache_version 109 --dir_cache /xdisk/khasting/knodele/vep_ref --offline --vcf -o {output} --force_overwrite --plugin Wildtype --symbol --terms SO --plugin Downstream --plugin Frameshift
		""" 


rule maf: 
	input: 
		os.path.join(vep_path, "{sample}_fake_mutations_vep.vcf")
	output: 
		os.path.join(vep_path, "{sample}_fake_mutations_vep.maf")
	params: 
		sample = lambda wildcards: config[wildcards.sample]["id"]
	shell: 
		"""
		perl /xdisk/khasting/knodele/programs/mskcc-vcf2maf-754d68a/vcf2maf.pl --inhibit-vep --input-vcf {input} --output-maf {output} --ref-fasta /xdisk/khasting/knodele/vep_ref/homo_sapiens/109_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --vep-path ~/miniconda3/envs/vep_env/bin --ncbi-build GRCh38 --tumor-id {params.sample}
		"""

