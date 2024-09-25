import os

configfile: "RNA_samples.json"

rule all:
	input:
		expand(os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.2.fastq"),sample=config["all_samples"])

rule map_hisat2:
        input:
                fq_1 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.1.fastq"),
                fq_2 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.2.fastq")
        output:
                sam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_sam/{sample}_RNA_HISAT2_genome_aligned.sam")
	params: 
		index = "/xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/hisat-index/GRCh38_combined_PAVE_hpv",
		threads = 8
        shell:
                """
                hisat2 -q --phred33 -p {params.threads} -x {params.index} -s no -1 {input.R1} -2 {input.R2} -S {output.SAM}
                """
