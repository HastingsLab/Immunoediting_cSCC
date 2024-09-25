# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P48","P47","P54","P58","P17","P19","P23","P25","P27","P28","P30","P34","P35","P36","P37",
"P38","P39A","P39B","P40","P41","P4","P5","P7","P8","P26","P24","P18","P59","P22","P20","P57",
"P55","P33","P49","P11","P2A","P14","P3", "P2B", "P6", "P13", "P9"]

configfile: "hla_types.json"

#Paths
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/"
output_path = "/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/binding/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_17.peptides_formatted"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_17.peptides_formatted"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(output_path, "{sample}_netmhc_fake_mutations.xsl"), sample=samples, peptide_path=peptide_path), # Mutant type binding
        expand(os.path.join(output_path, "{sample}_netmhc_fake_mutations_WT.xsl"), sample=samples, peptide_path=peptide_path) # Wild type binding

rule prepare_input_21:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_17.peptides")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_17.peptides_formatted")
        shell:
                """
                cat {input} | awk '{{print $1"."$5, $6}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output}
                """

rule netMHCpan_MT:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_17.peptides_formatted")
        output:
                os.path.join(output_path, "{sample}_netmhc_fake_mutations.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                /xdisk/khasting/knodele/programs/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 9 -xlsfile {output}
                """

rule prepare_input_21_WT:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_17.peptides")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_17.peptides_formatted")
        shell:
                """
                cat {input} | awk '{{print $1"."$7, $8}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output}
                """

rule netMHCpan_WT:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_17.peptides_formatted")
        output:
                os.path.join(output_path, "{sample}_netmhc_fake_mutations_WT.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                /xdisk/khasting/knodele/programs/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 9 -xlsfile {output}
                """
