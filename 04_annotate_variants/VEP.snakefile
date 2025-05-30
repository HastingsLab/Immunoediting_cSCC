# Setting up filesnames here:
from os.path import join
import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

rule all:
    input:
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep.vcf"), patient=config["all_patients"]), # run VEP
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/maf/{patient}.somaticvariants_filtered_vep.maf"), patient=config["all_patients"]) # make MAF file

rule gunzip_vcf:
	input: 
		os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.somatic.filtered.pass.vcf.gz")
	output:
		os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.somatic.filtered.pass.vcf")
	shell:
		"""
		gunzip -c {input} > {output}
		"""

rule concat: 
	input:
		snvs = "/xdisk/khasting/knodele/Mayo_data/strelka/{patient}/results/variants/somatic.snvs.pass.vcf.gz",
		indels = "/xdisk/khasting/knodele/Mayo_data/strelka/{patient}/results/variants/somatic.indels.pass.vcf.gz"
	output:
		"/xdisk/khasting/knodele/Mayo_data/strelka/{patient}/results/variants/somatic.concat.pass.vcf"
	shell:
		"""
		vcf-concat {input.snvs} {input.indels} > {output}
		"""

rule merge:
	input:
		gatk = os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/{patient}.somatic.filtered.pass.vcf"),
		strelka = os.path.join("/xdisk/khasting/knodele/Mayo_data/strelka/{patient}/results/variants/somatic.concat.pass.vcf")
	output:
		"/xdisk/khasting/knodele/Mayo_data/merged_variants/{patient}_gatk_strelka_intersection.txt"
	params: 
		patient = "{patient}", 
		outdir = "/xdisk/khasting/knodele/Mayo_data/merged_variants/"
	shell:
		"""
		python merge_gatk_strelka2.py --strelka {input.strelka} --gatk {input.gatk} --patient {params.patient} --outdir {params.outdir}
		"""
		

rule run_vep:
	input:
		os.path.join("/xdisk/khasting/knodele/Mayo_data/merged_variants/{patient}_gatk_strelka_intersection.txt")
	output:
		os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep.vcf")
	shell:
		"""
		/xdisk/khasting/knodele/programs/ensembl-vep/vep -i {input} --format vcf --assembly GRCh38 --cache -cache_version 109 --dir_cache /xdisk/khasting/knodele/vep_ref --offline --vcf -o {output} --force_overwrite --plugin Wildtype --symbol --tsl --terms SO --plugin Downstream --plugin Frameshift
		""" 


rule maf: 
	input: 
		os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep.vcf")
	output: 
		os.path.join("/xdisk/khasting/knodele/Mayo_data/maf/{patient}.somaticvariants_filtered_vep.maf")
	params: 
		sample = lambda wildcards: config[wildcards.patient]["tumor"],
		normal = lambda wildcards: config[wildcards.patient]["normal"]
	shell: 
		"""
		perl /xdisk/khasting/knodele/programs/mskcc-vcf2maf-754d68a/vcf2maf.pl --inhibit-vep --input-vcf {input} --output-maf {output} --ref-fasta /xdisk/khasting/knodele/vep_ref/homo_sapiens/109_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --vep-path ~/miniconda3/envs/vep_env/bin --ncbi-build GRCh38 --tumor-id {params.sample} --normal-id {params.normal}
		"""

