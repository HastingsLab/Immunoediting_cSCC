# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P10", "P11", "P12", "P13", "P14", "P15", "P16", "P17", "P18", "P19", "P1", "P20", "P21", "P22", "P23", "P24", "P25", "P26", "P27", "P28", "P29",
"P2A", "P2B", "P30", "P31", "P32", "P33", "P34", "P35", "P36", "P37", "P38", "P3", "P39A", "P39B", "P40", "P41", "P42", "P43", "P44", "P45", "P46", "P47", "P48", "P49", "P4",
"P50", "P51", "P52", "P52", "P53", "P54", "P55", "P56", "P57", "P58", "P59", "P5", "P6", "P7", "P8", "P9"]

configfile: "sample_id_config.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_human_data/vep/"
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/peptides/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides.vcf"), sample=samples, peptide_path=peptide_path), # run pVACseq
        expand(os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides_21.vcf"), sample=samples, peptide_path=peptide_path), # run pVACseq
        expand(os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_21.peptides"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT.peptides"), sample=samples, peptide_path=peptide_path), # Create WT peptide list
        expand(os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT_21.peptides"), sample=samples, peptide_path=peptide_path) # Create WT peptide list

rule generate_fasta:
	input:
		os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.vcf")
	output:
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides.vcf")
	params: 
		sample = lambda wildcards: config[wildcards.sample]["id"]
	shell:
		"""
		python ~/programs/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 8 {output} -s {params.sample};
		""" 

rule generate_fasta_21:
        input:
                os.path.join(vep_path, "{sample}.somaticvariants_filtered_vep.vcf")
        output:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides_21.vcf")
        params:
                sample = lambda wildcards: config[wildcards.sample]["id"]
        shell:
                """
                python ~/programs/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 10 {output} -s {params.sample};
                """

rule format_peptides: 
	input: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides.vcf")
	output: 
		os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep.peptides")
	shell: 
		"""
		cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
		"""

rule wildtype_peptides:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides.vcf")
        output:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>MT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """

rule format_peptides_21:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides_21.vcf")
        output:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_21.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """


rule wildtype_peptides_21:
        input:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_peptides_21.vcf")
        output:
                os.path.join(peptide_path, "{sample}.somaticvariants_filtered_vep_WT_21.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>MT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """
