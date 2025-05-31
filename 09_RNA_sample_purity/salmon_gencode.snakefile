import os

configfile: "RNA_sample.json"

rule all:
    input:
        expand("/xdisk/khasting/knodele/Mayo_data/salmon_read_counts/{sample}_salmon_gencode_quant/quant.sf", sample=config["all_samples"])

rule salmon_quant_paired:
	input:
		R1 = lambda wildcards: os.path.join("/xdisk/khasting/knodele/Mayo_data/RNA_fastqs/", config[wildcards.sample]["fq_1"]),
		R2 = lambda wildcards: os.path.join("/xdisk/khasting/knodele/Mayo_data/RNA_fastqs/", config[wildcards.sample]["fq_2"])
	output:
		os.path.join("/xdisk/khasting/knodele/Mayo_data/salmon_read_counts/{sample}_salmon_gencode_quant/quant.sf")
	params:
		SALMON_INDEX = "/xdisk/khasting/knodele/references/gencode_salmon_index",
		LIBTYPE = "A",
		outdir = "/xdisk/khasting/knodele/Mayo_data/salmon_read_counts/{sample}_salmon_gencode_quant/"
	shell:
		"""
		/xdisk/khasting/knodele/programs/salmon-latest_linux_x86_64/bin/salmon quant -i {params.SALMON_INDEX} -l {params.LIBTYPE} -1 {input.R1} -2 {input.R2} -o {params.outdir}
		"""

