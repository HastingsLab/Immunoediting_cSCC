# Setting up filesnames here:
from os.path import join
import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/hla_types_config.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_data/vep/"
peptide_path = "/xdisk/khasting/knodele/Mayo_data/vep/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_netmhc_WT.xsl"), sample=config["all_patients"], peptide_path=peptide_path),
        expand(os.path.join(peptide_path, "{sample}_netmhc_WT_9_10mer.xsl"), sample=config["all_patients"], peptide_path=peptide_path)

rule prepare_input:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT.peptides")
        output:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT.peptides_formatted")
        shell:
                """
                cat {input} | awk '{{print $1"."$7,$8}}' | sed 's/>WT.chr/>/' | sed 's/ /\\n/g' > {output}
                """

rule prepare_input_19mer:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT_19mer.peptides")
        output:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT_19mer.peptides_formatted")
        shell:
                """
                cat {input} | awk '{{print $1"."$7,$8}}' | sed 's/>WT.chr/>/' | sed 's/ /\\n/g' > {output}
                """


rule netMHCpan:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT.peptides_formatted")
        output:
                os.path.join(peptide_path, "{sample}_netmhc_WT.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                /home/u1/knodele/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 9 -xlsfile {output}
                """

rule netMHCpan_9_10mer:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT_19mer.peptides_formatted")
        output:
                os.path.join(peptide_path, "{sample}_netmhc_WT_9_10mer.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                /xdisk/khasting/knodele/programs/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 9,10 -xlsfile {output}
                """
