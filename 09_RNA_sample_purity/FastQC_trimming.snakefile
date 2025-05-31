import os

configfile: "RNA_sample.json"

adapter_path = "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/adapter_sequence.fa"

rule all:
    input:
        expand("/xdisk/khasting/knodele/Mayo_data/RNA_raw_fastqc_results/{sample}_fastqc.html", sample=config["all_fastqs"]),
        "/xdisk/khasting/knodele/Mayo_data/RNA_raw_multiqc_results/multiqc_report.html", #raw multiqc report


rule fastqc_analysis:
    input:
        fq = os.path.join("/xdisk/khasting/knodele/Mayo_data/RNA_fastqs/{sample}.fastq"),
    output:
        "/xdisk/khasting/knodele/Mayo_data/RNA_raw_fastqc_results/{sample}_fastqc.html"
    shell:
        """
        fastqc -o /xdisk/khasting/knodele/Mayo_data/RNA_raw_fastqc_results {input.fq}
        """

rule multiqc_analysis:
	input:
		expand(
			"/xdisk/khasting/knodele/Mayo_data/RNA_raw_fastqc_results/{sample}_fastqc.html",
			sample=config["all_fastqs"])
	output:
		"/xdisk/khasting/knodele/Mayo_data/RNA_raw_multiqc_results/multiqc_report.html"
	shell:
		"export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
		"multiqc --interactive -f "
		"-o /xdisk/khasting/knodele/Mayo_data/RNA_raw_multiqc_results /xdisk/khasting/knodele/Mayo_data/RNA_raw_fastqc_results"
