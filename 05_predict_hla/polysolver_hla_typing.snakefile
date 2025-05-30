#! importing join
from os.path import join

# Configuration file
configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

rule all:
    input:
        expand("/xdisk/khasting/knodele/Mayo_data/hla_types_new/{sample}/winners.hla.txt", sample=config["all_samples"]),
        expand("/xdisk/khasting/knodele/Mayo_data/hla_types_new/{sample}/hla_types.out", sample=config["all_samples"])

rule polysolver:
    input:
        bam = os.path.join("/xdisk/khasting/knodele/Mayo_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.mkdup.bam")
    output:
        output = os.path.join("/xdisk/khasting/knodele/Mayo_data/hla_types_new/{sample}/winners.hla.txt"),
    params:
        bam_dir = "/xdisk/khasting/knodele/Mayo_data/processed_bams/", # Change path - project specific
        in_file = "/data/{sample}.GRCh38_full_analysis_set_plus_decoy_hla.sorted.mkdup.bam", # DO NOT CHANGE PATH - singularity specific
        temp_dir = "/xdisk/khasting/knodele/Mayo_data/", # Change path - project specific
        out_dir = "/xdisk/khasting/knodele/Mayo_data/hla_types_new/", # Change path - project specific
        out_file = "/out/{sample}" # DO NOT CHANGE PATH - singularity specific
    message: "Identifying HLA types for {wildcards.sample} with polysolver."
    run:
        shell("singularity exec -C -B {params.bam_dir}:/data -B {params.temp_dir}:/tmp -B {params.out_dir}:/out /xdisk/khasting/knodele/programs/polysolver-singularity_v4.sif /home/polysolver/scripts/shell_call_hla_type {params.in_file} Unknown 1 hg38 STDFQ 0 {params.out_file}")

rule format:
    input:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/hla_types_new/{sample}/winners.hla.txt")
    output:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/hla_types_new/{sample}/hla_types.out")
    shell:
        """
        cat {input} | sed 's/\\t/\\n/g' | sed '/HLA/d' | sed 's/hla/HLA/g' | sed 's/a/A/g' | sed 's/b/B/g' | sed 's/c/C/g' | sed 's/_/\\t/g' | awk '{{print $1"-"$2""$3":"$4}}' | sed -z 's/\\n/,/g' | sed 's/,$/"\\n/' | sed 's/^/"hla": "/' > {output}
        """
