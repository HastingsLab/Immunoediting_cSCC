# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P48","P47","P54","P58","P17","P19","P23","P25","P27","P28","P30","P34","P35","P36","P37",
"P38","P39A","P39B","P40","P41","P4","P5","P7","P8","P26","P24","P18","P59","P22","P20","P57",
"P55","P33","P49","P11","P2A","P14","P3", "P2B", "P6", "P13", "P9"]

configfile: "hla_types.json"

#Paths
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/peptides/"

rule all:
    input:
        expand(os.path.join(peptide_path, "prime/{sample}_prime_output.txt"), sample=samples, peptide_path=peptide_path)

rule make_input:
	input:
		os.path.join(peptide_path, "{sample}_netmhc.xsl")
	output:
		os.path.join(peptide_path, "prime/{sample}_prime_input.txt")
	shell:
		"""
		Rscript prepare_peptides.R {input} {output}
		"""

rule PRIME:
        input:
                os.path.join(peptide_path, "prime/{sample}_prime_input.txt")
        output:
                os.path.join(peptide_path, "prime/{sample}_prime_output.txt")
        params:
                hla= lambda wildcards: config[wildcards.sample]["hla"]
        shell:
                """
                /xdisk/khasting/knodele/programs/PRIME/PRIME -i {input} -o {output} -mix /xdisk/khasting/knodele/programs/MixMHCpred/MixMHCpred -a {params.hla}
                """
