import os

configfile: "somatic_mutation_calling_config_abbr.json"

rule all:
    input:
        os.path.join(config["ref_dir"], "targets_C.preprocessed.interval_list"),
	expand(os.path.join("/xdisk/khasting/knodele/Mayo_human_data/processed_bams/{sample}." + config["ref_basename"] + ".hdf5"), sample=config["all_subjects"])

rule prep_refs:
    input:
        os.path.join(config["ref_dir"], config["ref_basename"] + ".fa")
    output:
        os.path.join(config["ref_dir"], "targets_C.preprocessed.interval_list")
    shell:
        """
        ~/programs/gatk-4.1.8.1/gatk PreprocessIntervals -L hg38_Twist_ILMN_Exome_2.0_Plus_Panel_annotated.BED -R {input} --bin-length 0 --interval-merging-rule OVERLAPPING_ONLY -O {output}
        """

rule index_mkdup:
    input:
        sample = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/processed_bams/{sample}." + config["ref_basename"] + ".sorted.mkdup.bam"),
        ref = os.path.join(config["ref_dir"], "targets_C.preprocessed.interval_list")
    output:
        os.path.join("/xdisk/khasting/knodele/Mayo_human_data/processed_bams/{sample}." + config["ref_basename"] + ".hdf5")
    shell:
        """
        ~/programs/gatk-4.1.8.1/gatk CollectReadCounts -I {input.sample} -L {input.ref} --interval-merging-rule OVERLAPPING_ONLY -O {output}
        """
