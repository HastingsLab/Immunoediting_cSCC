import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

rule all:
    input:
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.downsampled.bam.bai"), sample=config["new_samples"]),


rule mark_duplicates:
    input:
        bam = os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.bam"),
        bai = os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.bam.bai")
    output:
        bam = os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.mkdup_removed.bam"),
        metrics = os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}.picard_mkdup_metrics_removed.txt")
    threads: 4
    shell:
        "picard -Xmx14g MarkDuplicates REMOVE_DUPLICATES=true I={input.bam} O={output.bam} M={output.metrics}"

rule downsample:
    input:
        bam = os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.mkdup_removed.bam"),
    output:
        bam = os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.downsampled.bam"),
    threads: 4
    shell:
        "picard DownsampleSam I={input.bam} O={output.bam} P=0.5"

rule index:
    input:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.downsampled.bam")
    output:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.downsampled.bam.bai")
    shell:
        """
        samtools index {input}
        """

