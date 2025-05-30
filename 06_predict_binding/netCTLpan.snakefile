# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/hla_types_config.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_data/vep/"
peptide_path = "/xdisk/khasting/knodele/Mayo_data/vep/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_netctlpan_10mer.xsl"), sample=config["all_patients"], peptide_path=peptide_path)

rule netCTLpan:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_19mer.peptides_formatted")
        output:
                os.path.join(peptide_path, "{sample}_netctlpan_10mer.xsl")
        params:
                hla= "HLA-A02:01" # Since I only need proteasomal and TAP scores, putting a placeholder here, reminder not to use these bidning values
        shell:
                """
                /xdisk/khasting/knodele/programs/netCTLpan-1.1/netCTLpan -a {params.hla} -f {input} -s -xls -l 10 -xlsfile {output}
                """
