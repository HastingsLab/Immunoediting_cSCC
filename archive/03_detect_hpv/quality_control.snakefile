import os

configfile: "somatic_mutation_calling_config.json"

adapter_path = "~/Immunoediting_Human_cSCC/00_setup/adapter_sequence.fa"

rule all:
    input:
        "raw_multiqc_results/multiqc_report.html", #raw multiqc report
        "trimmed_multiqc_results/multiqc_report.html", #trimmed multiqc report


rule fastqc_analysis:
    input:
        fq_1 = lambda wildcards: os.path.join(config["fastq_path"], config[wildcards.sample]["fq_1"]),
        fq_2 = lambda wildcards: os.path.join(config["fastq_path"], config[wildcards.sample]["fq_2"])
    output:
        "raw_fastqc_results/{sample}_R1_fastqc.html",
        "raw_fastqc_results/{sample}_R3_fastqc.html"
    shell:
        """
        fastqc -o raw_fastqc_results {input.fq_1};
        fastqc -o raw_fastqc_results {input.fq_2}
        """

rule multiqc_analysis:
	input:
		expand(
			"raw_fastqc_results/{sample}_{read}_fastqc.html",
			sample=config["DNA_names"],
			read=["R1", "R3"])
	output:
		"raw_multiqc_results/multiqc_report.html"
	shell:
		"export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
		"multiqc --interactive -f "
		"-o raw_multiqc_results raw_fastqc_results"

rule trim_adapters_paired_bbduk:
    input:
        fq_1 = lambda wildcards: os.path.join(config["fastq_path"], config[wildcards.sample]["fq_1"]),
        fq_2 = lambda wildcards: os.path.join(config["fastq_path"], config[wildcards.sample]["fq_2"])
    output:
        out_fq_1 = "/xdisk/khasting/knodele/Mayo_human_data/fastq/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
        out_fq_2 = "/xdisk/khasting/knodele/Mayo_human_data/fastq/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz"
    params:
        adapter = adapter_path
    threads:
        2
    shell:
        "bbduk.sh -Xmx3g in1={input.fq_1} in2={input.fq_2} out1={output.out_fq_1} out2={output.out_fq_2} ref={params.adapter} qtrim=rl trimq=30 minlen=75 maq=20"

rule trimmed_fastqc_analysis:
    input:
        fq_1 = "/xdisk/khasting/knodele/Mayo_human_data/fastq/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
        fq_2 = "/xdisk/khasting/knodele/Mayo_human_data/fastq/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz"
    output:
        fq1_fastqc = "trimmed_fastqc_results/{sample}_trimmed_read1_fastqc.html",
        fq2_fastqc = "trimmed_fastqc_results/{sample}_trimmed_read2_fastqc.html"
    shell:
        """
        fastqc -o trimmed_fastqc_results {input.fq_1};
        fastqc -o trimmed_fastqc_results {input.fq_2}
        """

rule trimmed_multiqc_analysis:
	input:
		expand(
			"trimmed_fastqc_results/{sample}_trimmed_{read}_fastqc.html",
			sample=config["all_subjects"],
			read=["read1", "read2"])
	output:
		"trimmed_multiqc_results/multiqc_report.html"
	shell:
		"export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
		"multiqc --interactive -f "
		"-o trimmed_multiqc_results trimmed_fastqc_results"
