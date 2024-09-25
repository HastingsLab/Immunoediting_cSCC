import os

configfile: "RNA_samples.json"

rule all:
	input:
		expand(os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_sam/{sample}_RNA_HISAT2_genome_aligned.sam"),sample=config["all_samples"]),
		expand(os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_coverage.txt"),sample=config["all_samples"])

rule map_hisat2:
	input:
		R1 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.1.fastq"),
		R2 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.2.fastq")
	output:
		sam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_sam/{sample}_RNA_HISAT2_genome_aligned.sam")
	params: 
		index = "/xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/hisat-index/GRCh38_combined_PAVE_hpv",
		threads = 8
	shell:
		"""
		hisat2 -q --phred33 -p {params.threads} -x {params.index} -s no -1 {input.R1} -2 {input.R2} -S {output.sam}
		"""

rule sam_to_bam:
	input:
		sam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_sam/{sample}_RNA_HISAT2_genome_aligned.sam")
	output:
		bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned.bam")
	shell:
		"""
		samtools view -b -F 4 {input.sam} > {output.bam}
		"""

rule sort_bam:
	input:
		bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned.bam")
	output:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam")
	shell:
		"""
		samtools sort -O bam -o {output.sorted_bam} {input.bam}
		"""

rule index_bam:
	input:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam")    
	output:
		index = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam.bai")        
	shell:
		"""
		samtools index {input.sorted_bam}
		"""        

rule mark_duplicates:
	input:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam")    
	output:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup.bam"),
		metrics = os.path.join("{sample}.picard_mkdup_metrics.txt")
	threads: 4
	shell:
		"""
		picard -Xmx14g MarkDuplicates I={input.sorted_bam} O={output.sorted_bam} M={output.metrics}
		"""

rule readgroup:
	input:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup.bam")
	output:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam")
	params:
		sample="{sample}"
	shell:
		"""
		picard AddOrReplaceReadGroups I={input.sorted_bam} O={output.sorted_bam} RGID={params.sample} RGLB={params.sample} RGPL={params.sample} RGPU={params.sample} RGSM={params.sample}
		"""

rule index_mkdup_bam:
	input:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam")
	output:
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam.bai")
	shell:
		"""
		samtools index {input.sorted_bam}
		"""	

rule calculate_coverage:
	input: 
		sorted_bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam"),
		sorted_bam_bai = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam.bai")
	output:
		os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/{sample}_coverage.txt")
	shell:
		"""
		pileup.sh in={input.sorted_bam} out={output} secondary=TRUE
		"""
