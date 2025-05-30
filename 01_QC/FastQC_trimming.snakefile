import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

adapter_path = "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/adapter_sequence.fa"

rule all:
    input:
        expand("/xdisk/khasting/knodele/Mayo_data/raw_fastqc_results/{sample}_fastqc.html", sample=config["DNA_names"]),
        "/xdisk/khasting/knodele/Mayo_data/raw_multiqc_results/multiqc_report.html", #raw multiqc report
        expand("/xdisk/khasting/knodele/Mayo_data/trimmed_fastqs/{short}_trimmed_read1.fastq.gz", short=config["all_samples"]),
        "/xdisk/khasting/knodele/Mayo_data/trimmed_multiqc_results/multiqc_report.html", #trimmed multiqc report


rule fastqc_analysis:
    input:
        fq = os.path.join(config["fastq_path"], "{sample}.fastq.gz"),
    output:
        "/xdisk/khasting/knodele/Mayo_data/raw_fastqc_results/{sample}_fastqc.html"
    shell:
        """
        fastqc -o /xdisk/khasting/knodele/Mayo_data/raw_fastqc_results {input.fq}
        """

rule multiqc_analysis:
	input:
		expand(
			"/xdisk/khasting/knodele/Mayo_data/raw_fastqc_results/{sample}_fastqc.html",
			sample=config["DNA_names"])
	output:
		"/xdisk/khasting/knodele/Mayo_data/raw_multiqc_results/multiqc_report.html"
	shell:
		"export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
		"multiqc --interactive -f "
		"-o /xdisk/khasting/knodele/Mayo_data/raw_multiqc_results /xdisk/khasting/knodele/Mayo_data/raw_fastqc_results"

rule trim_adapters_paired_bbduk:
    input:
        fq_1 = lambda wildcards: os.path.join(config["fastq_path"], config[wildcards.short]["fq_1"]),
        fq_2 = lambda wildcards: os.path.join(config["fastq_path"], config[wildcards.short]["fq_2"])
    output:
        out_fq_1 = "/xdisk/khasting/knodele/Mayo_data/trimmed_fastqs/{short}_trimmed_read1.fastq.gz",
        out_fq_2 = "/xdisk/khasting/knodele/Mayo_data/trimmed_fastqs/{short}_trimmed_read2.fastq.gz"
    params:
        adapter = adapter_path
    threads:
        2
    shell:
        "bbduk.sh -Xmx3g in1={input.fq_1} in2={input.fq_2} out1={output.out_fq_1} out2={output.out_fq_2} ref={params.adapter} qtrim=rl trimq=30 minlen=75 maq=20"

rule trimmed_fastqc_analysis:
    input:
        fq_1 = "/xdisk/khasting/knodele/Mayo_data/trimmed_fastqs/{short}_trimmed_read1.fastq.gz",
        fq_2 = "/xdisk/khasting/knodele/Mayo_data/trimmed_fastqs/{short}_trimmed_read2.fastq.gz"
    output:
        fq1_fastqc = "/xdisk/khasting/knodele/Mayo_data/trimmed_fastqc_results/{short}_trimmed_read1_fastqc.html",
        fq2_fastqc = "/xdisk/khasting/knodele/Mayo_data/trimmed_fastqc_results/{short}_trimmed_read2_fastqc.html"
    shell:
        """
        fastqc -o /xdisk/khasting/knodele/Mayo_data/trimmed_fastqc_results {input.fq_1};
        fastqc -o /xdisk/khasting/knodele/Mayo_data/trimmed_fastqc_results {input.fq_2}
        """

rule trimmed_multiqc_analysis:
	input:
		expand(
			"/xdisk/khasting/knodele/Mayo_data/trimmed_fastqc_results/{short}_trimmed_{read}_fastqc.html",
			short=config["all_samples"],
			read=["read1", "read2"])
	output:
		"/xdisk/khasting/knodele/Mayo_data/trimmed_multiqc_results/multiqc_report.html"
	shell:
		"export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
		"multiqc --interactive -f "
		"-o /xdisk/khasting/knodele/Mayo_data/trimmed_multiqc_results /xdisk/khasting/knodele/Mayo_data/trimmed_fastqc_results"
