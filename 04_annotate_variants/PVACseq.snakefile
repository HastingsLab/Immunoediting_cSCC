# Setting up filesnames here:
from os.path import join
import os

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

rule all:
    input:
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides.vcf"), patient=config["all_patients"]), # run pVACseq
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep.peptides"), patient=config["all_patients"]),
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_WT.peptides"), patient=config["all_patients"]), # Create WT peptide list
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_19mer.peptides"), patient=config["all_patients"]), # Create peptide list 19mer
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_WT_19mer.peptides"), patient=config["all_patients"]), # Create WT peptide list, 19mer
	expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_31mer.peptides"), patient=config["all_patients"]),
	expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_31mer_WT.peptides"), patient=config["all_patients"])

rule reheader:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_reheadered.vcf")
	params:
		header = "/xdisk/khasting/knodele/Mayo_data/gatk_mutect2/header_info.txt"
	shell:
                """
		cat {params.header} {input} > {output}
                """

rule remove_id:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_reheadered.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_abbr.vcf")
        shell:
                """
                cut --complement -f12 {input} > {output}
                """

rule generate_fasta:
	input:
		os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_abbr.vcf")
	output:
		os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides.vcf")
	params: 
		sample = lambda wildcards: config[wildcards.patient]["tumor"]
	shell:
		"""
		python /xdisk/khasting/knodele/programs/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 8 {output} -s {params.sample};
		""" 

rule generate_fasta_19mer:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_abbr.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides_19mer.vcf")
        params:
                sample = lambda wildcards: config[wildcards.patient]["tumor"]
        shell:
                """
                python /xdisk/khasting/knodele/programs/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 9 {output} -s {params.sample};
                """

rule generate_fasta_31mer:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_abbr.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides_31mer.vcf")
        params:
                sample = lambda wildcards: config[wildcards.patient]["tumor"]
        shell:
                """
                python /xdisk/khasting/knodele/programs/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 15 {output} -s {params.sample};
                """


rule format_peptides: 
	input: 
		os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides.vcf")
	output: 
		os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep.peptides")
	shell: 
		"""
		cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
		"""

rule format_peptides_19mer:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides_19mer.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_19mer.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """

rule format_peptides_31mer:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides_31mer.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_31mer.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """

rule format_peptides_31mer_WT:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides_31mer.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_31mer_WT.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>MT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """

rule wildtype_peptides:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_WT.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>MT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
		"""

rule wildtype_peptides_19mer:
        input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_peptides_19mer.vcf")
        output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/vep/{patient}.somaticvariants_filtered_vep_WT_19mer.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>MT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """
