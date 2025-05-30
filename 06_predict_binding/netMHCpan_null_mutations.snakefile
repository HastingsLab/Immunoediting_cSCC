# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P001","P055","P13","P18","P26","P34","P3","P54","P7","P002","P062","P14","P19","P27","P35","P40","P55","P8",
"P004","P083","P164","P20","P28","P36","P41","P57","P9","P010","P113","P169","P22","P2A","P37","P47","P58","P015","P11",
"P17","P23","P2B","P38", "P48", "P59","P017","P133","P182","P24","P30","P39A","P49","P5","P050","P138","P183","P25","P33",
"P39B","P4","P6"]

part = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18",
"19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39",
"40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60",
"61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81",
"82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99"]

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/hla_types_config.json"

#Paths
peptide_path = "/xdisk/khasting/knodele/Mayo_data/In_silico_muts"
output_path = "/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/"

rule all:
    input:
        #expand(os.path.join(output_path, "{sample}_fake_mutations_vep_19.peptides_formatted_{part}"), sample=samples, part=part, output_path=output_path),
        #expand(os.path.join(output_path, "{sample}_fake_mutations_vep_WT_19.peptides_formatted_{part}"), sample=samples, part=part, output_path=output_path),
        expand(os.path.join(output_path, "{sample}_netmhc_fake_mutations_{part}.xsl"), sample=samples, part=part, output_path=output_path), # Mutant type binding
        expand(os.path.join(output_path, "{sample}_fake_mutations_vep_WT_all_9mer.peptides"), sample=samples, output_path=output_path) # Wild type binding

rule prepare_input_21:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_19.peptides")
        output:
                os.path.join(output_path, "{sample}_fake_mutations_vep_19.peptides_formatted")
        shell:
                """
                cat {input} | awk '{{print $1"."$5, $6}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output}
                """

rule split_100_parts:
	input:
		os.path.join(output_path, "{sample}_fake_mutations_vep_19.peptides_formatted")
	output:
		expand(os.path.join(output_path, "{{sample}}_fake_mutations_vep_19.peptides_formatted_{part}"), part=part)
	params:
		sample = "/xdisk/khasting/knodele/Mayo_data/In_silico_muts/binding/{sample}_fake_mutations_vep_19.peptides_formatted_"
	shell:
		"""
		split -d -n 100 {input} {params.sample}
		"""

rule netMHCpan_MT:
        input:
                os.path.join(output_path, "{sample}_fake_mutations_vep_19.peptides_formatted_{part}")
        output:
                os.path.join(output_path, "{sample}_netmhc_fake_mutations_{part}.xsl")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                /xdisk/khasting/knodele/programs/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input} -BA -s -xls -l 9,10 -xlsfile {output}
                """

rule prepare_input_21_WT:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_19.peptides")
        output:
                os.path.join(output_path, "{sample}_fake_mutations_vep_WT_all_9mer.peptides")
        shell:
                """
                python split_strings.python -i {input} -o {output}
                """
