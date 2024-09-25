# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
subjects = ["P10", "P11", "P12", "P13", "P14", "P15", "P16", "P17", "P18", "P19", "P1", "P20", "P21", "P22", "P23", "P24", "P25", "P26", "P27", "P28", "P29",
"P2A", "P2B", "P30", "P31", "P32", "P33", "P34", "P35", "P36", "P37", "P38", "P39A", "P39B", "P3", "P40", "P41", "P42", "P43", "P44", "P45", "P46", "P47", "P48", "P49", "P4",
"P50", "P51", "P52", "P52", "P53", "P54", "P55", "P56", "P57", "P58", "P59", "P5", "P6", "P7", "P8", "P9"]
#subjects = ["P1"]

configfile: "sample_id_config.json"

#Paths
hla_path = "/xdisk/khasting/knodele/Mayo_human_data/hla_types/"

rule all:
    input:
        expand(os.path.join(hla_path, "{subject}_hla.json"), subject=subjects, hla_path=hla_path)

rule prepare_input: 
	output: 
		os.path.join(hla_path, "{subject}_hla.json")
	params: 
		sample = lambda wildcards: config[wildcards.subject]["id"],
		subject = "{subject}"
	shell: 
		"""
		python hla_extraction.py --sample {params.sample} --subject {params.subject}  --outfile {output}
		"""

