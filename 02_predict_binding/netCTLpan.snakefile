# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P10", "P11", "P12", "P13", "P14", "P15", "P16", "P17", "P18", "P19", "P1", "P20", "P21", "P22", "P23", "P24", "P25", "P26", "P27", "P28", "P29",
"P2A", "P2B", "P30", "P31", "P32", "P33", "P34", "P35", "P36", "P37", "P38", "P39A", "P39B", "P3", "P40", "P41", "P42", "P43", "P45", "P46", "P47", "P48", "P49", "P4",
"P50", "P51", "P52", "P53", "P54", "P55", "P56", "P57", "P58", "P59", "P5", "P7", "P8", "P9", "P6", "P44"]
#samples = ["P1"]

configfile: "hla_types.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_human_data/vep/"
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/peptides/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_netctlpan.xsl"), sample=samples, peptide_path=peptide_path)

rule netMHCpan_all_lengths:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides_formatted")
        output:
                os.path.join(peptide_path, "{sample}_netctlpan.xsl")
        params:
                hla= "HLA-A02:01" # Since I only need proteasomal and TAP scores, putting a placeholder here, reminder not to use these bidning values
        shell:
                """
                /home/u1/knodele/programs/netCTLpan-1.1/netCTLpan -a {params.hla} -f {input} -s -xls -l 9 -xlsfile {output}
                """
