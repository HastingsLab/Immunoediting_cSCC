# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P10", "P11", "P12", "P13", "P14", "P15", "P16", "P17", "P18", "P19", "P1", "P20", "P21", "P22", "P23", "P24", "P25", "P26", "P27", "P28", "P29",
"P2A", "P2B", "P30", "P31", "P32", "P33", "P34", "P35", "P36", "P37", "P38", "P39A", "P39B", "P3", "P40", "P41", "P42", "P43", "P45", "P46", "P47", "P48", "P49", "P4",
"P50", "P51", "P52", "P52", "P53", "P54", "P55", "P56", "P57", "P58", "P59", "P5", "P7", "P8", "P9", "P6", "P44"]
#samples = ["P1"]

configfile: "hla_types.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_human_data/vep/"
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/peptides/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides_formatted"), sample=samples, peptide_path=peptide_path)
#        expand(os.path.join(peptide_path, "{sample}_netmhc.xsl"), sample=samples, peptide_path=peptide_path),
#        expand(os.path.join(peptide_path, "{sample}_netmhc_all_lengths.xsl"), sample=samples, peptide_path=peptide_path),
#	expand(os.path.join(peptide_path, "{sample}_netmhcstab.xsl"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(peptide_path, "{sample}_netmhcstab_all_lengths.xsl"), sample=samples, peptide_path=peptide_path)

rule prepare_input:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides")
        output:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides_formatted")
        shell:
                """
                cat {input} | awk '{{print $1"."$5, $6}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output}
                """

rule prepare_input_21: 
	input: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_21.peptides")
	output: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_21.peptides_formatted")
	shell: 
		"""
		cat {input} | awk '{{print $1"."$5, $6}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output}
		"""

rule netMHCpan: 
	input: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides_formatted")
	output: 
		os.path.join(peptide_path, "{sample}_netmhc.xsl")
	params: 
		hla= lambda wildcards: config[wildcards.sample]["hla"]
	shell: 
		"""
		/home/u1/knodele/programs/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 9 -xlsfile {output}
		"""

rule netMHCstabpan:
	input: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides_formatted")
	output:
		os.path.join(peptide_path, "{sample}_netmhcstab.xsl")
	params: 
		hla= lambda wildcards: config[wildcards.sample]["hla"]
	shell:
		"""
		singularity exec ~/programs/netMHCstabpan.sif netMHCstabpan -a {params.hla} -f {input} -s -xls -l 9 -xlsfile {output}
		"""

rule netMHCpan_all_lengths:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_21.peptides_formatted")
        output:
                os.path.join(peptide_path, "{sample}_netmhc_all_lengths.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                /home/u1/knodele/programs/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 8,9,10,11 -xlsfile {output}
                """

rule netMHCstabpan_21:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_21.peptides_formatted")
        output:
                os.path.join(peptide_path, "{sample}_netmhcstab_all_lengths.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                singularity exec ~/programs/netMHCstabpan.sif netMHCstabpan -a {params.hla} -f {input} -s -xls -l 9 -xlsfile {output}
                """
