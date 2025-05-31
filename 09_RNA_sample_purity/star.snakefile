import os

configfile: "RNA_sample.json"

sample_test = ["s_CSCC_16"]

rule all:
    input:
        expand("/xdisk/khasting/knodele/Mayo_data/star_mapped_reads/{sample}Aligned.out.sam", sample=config["all_samples"]),
	expand("/xdisk/khasting/knodele/Mayo_data/star_mapped_reads/readcounts/all_samples.counts.txt")


rule star_align:
	input:
		R1 = lambda wildcards: os.path.join("/xdisk/khasting/knodele/Mayo_data/RNA_fastqs/", config[wildcards.sample]["fq_1"]),
		R2 = lambda wildcards: os.path.join("/xdisk/khasting/knodele/Mayo_data/RNA_fastqs/", config[wildcards.sample]["fq_2"])
	output:
		os.path.join("/xdisk/khasting/knodele/Mayo_data/star_mapped_reads/{sample}Aligned.out.sam")
	params:
		outdir = "/xdisk/khasting/knodele/Mayo_data/star_mapped_reads/{sample}"
	shell:
		"""
		STAR --runThreadN 20 --genomeDir /xdisk/khasting/knodele/references/1000genomes_GRCh38_reference_genome/GRCh38_star --readFilesIn {input.R1} {input.R2} --outFileNamePrefix {params.outdir}
		"""

rule subread_featurecounts:
	input: 
		expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/star_mapped_reads/{sample}Aligned.out.sam"), sample=config["all_samples"])
	output: 
		os.path.join("/xdisk/khasting/knodele/Mayo_data/star_mapped_reads/readcounts/all_samples.counts.txt")
	shell:
		"""
		featureCounts -T 30 --countReadPairs -O --primary -p -s 2 -t exon -g gene_id -a /xdisk/khasting/knodele/references/1000genomes_GRCh38_reference_genome/gencode.v47.annotation.gtf -o {output} {input}
		"""
