import os

configfile: "RNA_samples.json"

rule all:
	input:
		expand(os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.2.fastq"),sample=config["all_samples"])

rule extract_bams:
        input:
                bam = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}.bam")
        output:
                map_map = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_map_map.bam"),
                unmap_map = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmap_map.bam"),
                map_unmap = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_map_unmap.bam"),
                unmap_unmap = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmap_unmap.bam")
        shell:
                """
                samtools view -u -f 1 -F 12 {input.bam} > {output.map_map};
                samtools view -u -f 4 -F 264 {input.bam} > {output.unmap_map};
                samtools view -u -f 8 -F 260 {input.bam} > {output.map_unmap};
                samtools view -u -f 12 -F 256 {input.bam} > {output.unmap_unmap};
                """

rule merge_bams:
        input:
                unmap_map = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmap_map.bam"),
                map_unmap = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_map_unmap.bam"),
                unmap_unmap = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmap_unmap.bam")
        output:
                unmapped = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.bam")
        shell:
                """
                samtools merge -u {output.unmapped} {input.unmap_map} {input.map_unmap} {input.unmap_unmap}
                """

rule sort:
        input:
                mapped = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_map_map.bam"),
                unmapped = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.bam")
        output:
                mapped = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_map_map.sort.bam"),
                unmapped = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.sort.bam")
        shell:
                """
                samtools sort -n {input.mapped} -o {output.mapped};
                samtools sort -n {input.unmapped} -o {output.unmapped}
                """

rule extract_fastqs:
        input:
                mapped = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_map_map.sort.bam"),
                unmapped = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.sort.bam")
        output:
                mapped_fq_1 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_mapped.1.fastq"),
                mapped_fq_2  = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_mapped.2.fastq"),
                unmapped_fq_1 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.1.fastq"),
                unmapped_fq_2 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.2.fastq")
        shell:
                """
                bamToFastq -i {input.mapped} -fq {output.mapped_fq_1} -fq2 {output.mapped_fq_2}
                bamToFastq -i {input.unmapped} -fq {output.unmapped_fq_1} -fq2 {output.unmapped_fq_2}
                """

rule combine_fastqs:
        input:
                mapped_fq_1 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_mapped.1.fastq"),
                mapped_fq_2  = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_mapped.2.fastq"),
                unmapped_fq_1 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.1.fastq"),
                unmapped_fq_2 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_primary_bams/{sample}_unmapped.2.fastq")
        output:
                fq_1 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.1.fastq"),
                fq_2 = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/RNA_fastqs/{sample}.2.fastq")
        shell:
                """
                cat {input.mapped_fq_1} {input.unmapped_fq_1} > {output.fq_1}
                cat {input.mapped_fq_2} {input.unmapped_fq_2} > {output.fq_2}
                """
