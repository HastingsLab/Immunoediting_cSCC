# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
iteration = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

configfile: "hla_types_scrambled.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_data/vep/"
peptide_path = "/xdisk/khasting/knodele/Mayo_data/vep/"
output_path = "/xdisk/khasting/knodele/Mayo_data/vep/scrambled_binding"

rule all:
    input:
        expand(os.path.join(output_path, "{sample}_netmhc_scrambled_{iteration}.xsl"), sample=config["all_patients"], iteration=iteration, peptide_path=peptide_path),


rule netMHCpan_all_lengths:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides_formatted")
        output:
                os.path.join(output_path, "{sample}_netmhc_scrambled_{iteration}.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample][wildcards.iteration]
        shell:
                """
                /home/u1/knodele/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 9 -xlsfile {output}
                """
