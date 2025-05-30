# Setting up filesnames here:
from os.path import join
import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

#Paths
hla_path = "/xdisk/khasting/knodele/Mayo_data/hla_types_new/"


rule all:
    input:
        expand(os.path.join(hla_path, "{subject}_hla.json"), subject=config["all_patients"], hla_path=hla_path),
	expand(os.path.join(hla_path, "{subject}_hla_normal.json"), subject=config["all_patients"], hla_path=hla_path)

rule prepare_input: 
	output: 
		os.path.join(hla_path, "{subject}_hla.json")
	params: 
		sample = lambda wildcards: config[wildcards.subject]["tumor"],
		subject = "{subject}"
	shell: 
		"""
		python hla_extraction.py --sample {params.sample} --subject {params.subject}  --outfile {output}
		"""

rule prepare_input_WT:
        output:
                os.path.join(hla_path, "{subject}_hla_normal.json")
        params:
                sample = lambda wildcards: config[wildcards.subject]["normal"],
                subject = "{subject}"
        shell:
                """
                python hla_extraction.py --sample {params.sample} --subject {params.subject}  --outfile {output}
                """
