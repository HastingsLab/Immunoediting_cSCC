# Setting up filesnames here:
from os.path import join
import os


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

