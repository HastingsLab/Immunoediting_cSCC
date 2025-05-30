#! importing join
from os.path import join

# Configuration file
configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

rule all:
    input:
        expand("/xdisk/khasting/knodele/Mayo_data/hla_class_II/{sample}/result/{sample}_final.result.txt", sample=config["all_samples"])

rule gunzip:
    input:
        fastq1 = lambda wildcards: os.path.join("/xdisk/khasting/knodele/Mayo_data/fastq/", config[wildcards.sample]["fq_1"]),
        fastq2 = lambda wildcards: os.path.join("/xdisk/khasting/knodele/Mayo_data/fastq/", config[wildcards.sample]["fq_2"])
    output:
        fastq1 = os.path.join("/xdisk/khasting/knodele/Mayo_data/fastq/{sample}_1.fastq"),
        fastq2 = os.path.join("/xdisk/khasting/knodele/Mayo_data/fastq/{sample}_2.fastq")
    shell:
        """
        gunzip -c {input.fastq1} > {output.fastq1};
        gunzip -c {input.fastq2} > {output.fastq2}
        """

rule hlahd:
    input:
        fastq1 = os.path.join("/xdisk/khasting/knodele/Mayo_data/fastq/{sample}_1.fastq"),
        fastq2 = os.path.join("/xdisk/khasting/knodele/Mayo_data/fastq/{sample}_2.fastq") 
    output:
        output = os.path.join("/xdisk/khasting/knodele/Mayo_data/hla_class_II/{sample}/result/{sample}_final.result.txt"),
    params:
       sample = "{sample}",
       outdir = "/xdisk/khasting/knodele/Mayo_data/hla_class_II"
    message: "Identifying HLA class II types for {wildcards.sample} with HLA-HD."
    run:
        shell("hlahd.sh {input.fastq1} {input.fastq2} /xdisk/khasting/knodele/programs/hlahd.1.7.1/HLA_gene.split.txt /xdisk/khasting/knodele/programs/hlahd.1.7.1/dictionary/ {params.sample} {params.outdir}")

