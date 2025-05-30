import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

rule all:
    input:
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.vcf.gz"), patient=config["new_patients"]),
	expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.artifact-prior-table.tsv"), patient=config["new_patients"]),
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.read-orientation-model.tar.gz"), patient=config["new_patients"]),
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.filtered.vcf.gz"), patient=config["new_patients"]),
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.filtered.pass.vcf.gz"), patient=config["new_patients"])

rule tumor_with_matched_normal:
    input:
        ref = os.path.join(config["ref_dir"], config["ref_basename"] + ".fa"),
        normal_bam = lambda wildcards: os.path.join(
			"/xdisk/khasting/knodele/Mayo_data/processed_bams/", config[wildcards.patient]["normal"] + "." + config["ref_basename"] + ".sorted.downsampled.bam"),
        tumor_bam = lambda wildcards: os.path.join(
			"/xdisk/khasting/knodele/Mayo_data/processed_bams/", config[wildcards.patient]["tumor"] + "." + config["ref_basename"] + ".sorted.downsampled.bam")
    output:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.vcf.gz")
    threads: 4
    params:
        gatk = "/xdisk/khasting/knodele/programs/gatk-4.1.8.1/gatk",
        sm = lambda wildcards: config[wildcards.patient]["normal"]
    shell:
        """
        export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
        {params.gatk} Mutect2 -R {input.ref} -I {input.tumor_bam} -I {input.normal_bam} -normal {params.sm} --max-mnp-distance 0 -O {output}
        """

rule CollectF1R2Counts:
    input:
        ref = os.path.join(config["ref_dir"], config["ref_basename"] + ".fa"),
        tumor_bam = lambda wildcards: os.path.join(
                        "/xdisk/khasting/knodele/Mayo_data/processed_bams/", config[wildcards.patient]["tumor"] + "." + config["ref_basename"] + ".sorted.downsampled.bam")
    output:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.artifact-prior-table.tsv")
    params:
        gatk = "/xdisk/khasting/knodele/programs/gatk-4.1.8.1/gatk",
    shell:
        """
        {params.gatk} CollectF1R2Counts -R {input.ref} -I {input.tumor_bam} -O {output}
        """

rule LearnReadOrientationModel:
    input:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.artifact-prior-table.tsv")
    output:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.read-orientation-model.tar.gz")
    params:
        gatk = "/xdisk/khasting/knodele/programs/gatk-4.1.8.1/gatk",
    shell:
        """
        {params.gatk} LearnReadOrientationModel -I {input} -O {output}
        """

rule filter:
    input:
        ref = os.path.join(config["ref_dir"], config["ref_basename"] + ".fa"),
        unfiltered = os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.vcf.gz"),
        ob_priors = os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.read-orientation-model.tar.gz")
    output:
        filtered = os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.filtered.vcf.gz")
    params:
        gatk = "/xdisk/khasting/knodele/programs/gatk-4.1.8.1/gatk"
    shell:
        """
        {params.gatk} FilterMutectCalls -R {input.ref} -V {input.unfiltered} --unique-alt-read-count 2 --min-reads-per-strand 1 --ob-priors {input.ob_priors} -O {output.filtered}
        """

rule select_pass_variants:
    input:
        ref = os.path.join(config["ref_dir"], config["ref_basename"] + ".fa"),
        vcf = os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.filtered.vcf.gz")
    output:
        os.path.join("/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/", "{patient}.downsampled.somatic.filtered.pass.vcf.gz")
    params:
        gatk = "/xdisk/khasting/knodele/programs/gatk-4.1.8.1/gatk"
    shell:
        """
        {params.gatk} SelectVariants -R {input.ref} -V {input.vcf} --exclude-filtered -O {output}
        """
