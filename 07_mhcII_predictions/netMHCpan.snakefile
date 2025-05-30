# Setting up filesnames here:
from os.path import join
import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/hla_classII_types.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_data/vep/"
peptide_path = "/xdisk/khasting/knodele/Mayo_data/vep/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_netmhcII.xsl"), sample=config["all_patients"], peptide_path=peptide_path),


rule prepare_input_19mer: 
	input: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_31mer.peptides")
	output: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_31mer.peptides_formatted")
	shell: 
		"""
		cat {input} | awk '{{print $1"."$5, $6}}' | sed 's/>MT.chr/>/' | sed 's/ /\\n/g' | sed -e '1,2d' > {output}
		"""

rule netMHCpan: 
	input: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_31mer.peptides_formatted")
	output: 
		os.path.join(peptide_path, "{sample}_netmhcII.xsl")
	params: 
		hla= lambda wildcards: config[config[wildcards.sample]["tumor"]]["hla"]
	shell: 
		"""
		/xdisk/khasting/knodele/programs/netMHCIIpan-4.3/netMHCIIpan -a {params.hla} -f {input} -BA -s -xls -length 15 -xlsfile {output}
		"""
