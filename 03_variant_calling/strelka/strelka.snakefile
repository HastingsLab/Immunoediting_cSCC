import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

rule all:
    input:
        expand("/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/runWorkflow.py", subject=config["all_patients"]),
        expand("/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.snvs.vcf.gz", subject=config["all_patients"]),
        expand("/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.indels.vcf.gz", subject=config["all_patients"]),
        expand("/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.snvs.pass.vcf.gz", subject=config["all_patients"]),
        expand("/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.indels.pass.vcf.gz", subject=config["all_patients"]),

rule config:
    input:
        normal_bam = lambda wildcards: os.path.join(
			"/xdisk/khasting/knodele/Mayo_data/processed_bams/", config[wildcards.subject]["normal"] + "." + config["ref_basename"] + ".sorted.mkdup.bam"),
        tumor_bam = lambda wildcards: os.path.join(
			"/xdisk/khasting/knodele/Mayo_data/processed_bams/", config[wildcards.subject]["tumor"] + "." + config["ref_basename"] + ".sorted.mkdup.bam"),
        ref = os.path.join(config["ref_dir"], config["ref_basename"] + ".fa")
    output:
        "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/runWorkflow.py"
    params:
        strelka = "/xdisk/khasting/knodele/programs/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py",
        run_dir = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}"
    shell:
        """
        {params.strelka} --normalBam {input.normal_bam} --tumorBam {input.tumor_bam} --referenceFasta {input.ref} --runDir {params.run_dir}
        """

rule run:
    input:
        normal_bam = lambda wildcards: os.path.join(
			"/xdisk/khasting/knodele/Mayo_data/processed_bams/", config[wildcards.subject]["normal"] + "." + config["ref_basename"] + ".sorted.mkdup.bam"),
        tumor_bam = lambda wildcards: os.path.join(
			"/xdisk/khasting/knodele/Mayo_data/processed_bams/", config[wildcards.subject]["tumor"] + "." + config["ref_basename"] + ".sorted.mkdup.bam"),
        ref = os.path.join(config["ref_dir"], config["ref_basename"] + ".fa")
    output:
        snvs = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.snvs.vcf.gz",
        indels = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.indels.vcf.gz"
    params:
        run = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/runWorkflow.py"
    shell:
        """
        {params.run} -m local -j 20
        """

rule select_pass_variants:
    input:
        ref = os.path.join(config["ref_dir"], config["ref_basename"] + ".fa"),
        snvs = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.snvs.vcf.gz",
        indels = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.indels.vcf.gz"
    output:
        snvs = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.snvs.pass.vcf.gz",
        indels = "/xdisk/khasting/knodele/Mayo_data/strelka/{subject}/results/variants/somatic.indels.pass.vcf.gz"
    params:
        gatk = "/xdisk/khasting/knodele/programs/gatk-4.1.8.1/gatk"
    shell:
        """
        {params.gatk} SelectVariants -R {input.ref} -V {input.snvs} --exclude-filtered -O {output.snvs};
        {params.gatk} SelectVariants -R {input.ref} -V {input.indels} --exclude-filtered -O {output.indels}
        """
