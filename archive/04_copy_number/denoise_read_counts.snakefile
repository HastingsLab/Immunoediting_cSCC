import os

configfile: "somatic_mutation_calling_config_abbr.json"

rule all:
	input:
		expand(os.path.join("/xdisk/khasting/knodele/Mayo_human_data/copy_ratios/{sample}." + config["ref_basename"] + ".denoisedCR.tsv"), sample=config["tumor_samples"]),
		#expand(os.path.join("/xdisk/khasting/knodele/Mayo_human_data/copy_ratios/{sample}." + config["ref_basename"] + ".denoised.png"), sample=config["tumor_samples"])

rule denoise:
	input:
		hdf5_input = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/processed_bams/{sample}." + config["ref_basename"] + ".hdf5")
	output:
		standardized_CR = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/copy_ratios/{sample}." + config["ref_basename"] + ".standardizedCR.tsv"),
		denoised_CR = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/copy_ratios/{sample}." + config["ref_basename"] + ".denoisedCR.tsv")
	shell:
		"""
		~/programs/gatk-4.1.8.1/gatk --java-options "-Xmx12g" DenoiseReadCounts -I {input.hdf5_input} \
		--count-panel-of-normals /xdisk/khasting/knodele/Mayo_human_data/processed_bams/Mayo_PON.hdf5 \
		--standardized-copy-ratios {output.standardized_CR} \
		--denoised-copy-ratios {output.denoised_CR}
		"""

rule plot:
	input: 
		standardized_CR = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/copy_ratios/{sample}." + config["ref_basename"] + ".standardizedCR.tsv"),
                denoised_CR = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/copy_ratios/{sample}." + config["ref_basename"] + ".denoisedCR.tsv")
	output:
		output = os.path.join("/xdisk/khasting/knodele/Mayo_human_data/copy_ratios/{sample}." + config["ref_basename"] + ".denoised.png")
	params: 
		os.path.join("{sample}." + config["ref_basename"])
	shell:
		"""
		~/programs/gatk-4.1.8.1/gatk PlotDenoisedCopyRatios \
		--standardized-copy-ratios {input.standardized_CR} \
		--denoised-copy-ratios {input.denoised_CR} \
		--sequence-dictionary /xdisk/khasting/knodele/references/1000genomes_combined_PAVE_hpv_ref/GRCh38_combined_PAVE_hpv.dict \
		--minimum-contig-length 46709983 \
		--output /xdisk/khasting/knodele/Mayo_human_data/cr_plots \
		--output-prefix {params}
		"""
