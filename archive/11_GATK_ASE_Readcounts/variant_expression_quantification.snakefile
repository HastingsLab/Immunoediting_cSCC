#! importing join
from os.path import join

# Directories

vep_path = "/xdisk/khasting/knodele/Mayo_human_data/vep/"
bam_dir = "/xdisk/khasting/knodele/Mayo_human_data/RNA_realigned_bam/"
exp_dir = "/xdisk/khasting/knodele/Mayo_human_data/gatk_asereadcounts/"

# Samples

configfile: "somatic_mutation_calling_config.json"

rule all: 
     input: 
        expand(exp_dir  +"{sample}_gatk_filtered_expression.out", sample=config["patients"], exp_dir=exp_dir)

rule remove_duplicates:
    input:    
        vep = os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.vcf"),
        ref = "/xdisk/khasting/knodele/references/1000genomes_GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"
    output:
        vep = os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep_biall.vcf")
    params:
        gatk = "~/programs/gatk-4.5.0.0/gatk"
    shell:
        """
        {params.gatk} SelectVariants --V {input.vep} --restrict-alleles-to BIALLELIC -O {output.vep};
        """

rule index_vcf:
    input: 
        vep = os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep_biall.vcf")
    output:
        vep = os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep_biall.vcf.idx")
    params: 
        gatk = "~/programs/gatk-4.5.0.0/gatk"
    shell:
        """
        {params.gatk} IndexFeatureFile -I {input.vep};
        """

rule gatk_asereadcounter:
    input: 
        BAM = lambda wildcards: os.path.join(bam_dir, config[wildcards.sample]["rna"] + "_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam"),
        vep = os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep_biall.vcf"),
        idx = os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep_biall.vcf.idx")
    output:
        exp = os.path.join(exp_dir, "{sample}_gatk_filtered_expression.tsv")
    params:
        gatk = "~/programs/gatk-4.5.0.0/gatk",
        ref = "/xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/GRCh38_combined_PAVE_hpv.fa"
    shell: 
        """
        {params.gatk} ASEReadCounter --output {output.exp} --input {input.BAM} --R {params.ref} --variant {input.vep};  
        """

rule format_output:
    input:
        exp = os.path.join(exp_dir, "{sample}_gatk_filtered_expression.tsv")
    output:
        exp = os.path.join(exp_dir, "{sample}_gatk_filtered_expression.out")
    shell:
        """
        cat {input.exp} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.exp};
        """

