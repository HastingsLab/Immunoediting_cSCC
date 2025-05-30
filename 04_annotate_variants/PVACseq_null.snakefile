# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P001","P055","P13","P18","P26","P34","P3","P54","P7","P002","P062","P14","P19","P27","P35","P40","P55","P8",
"P004","P083","P164","P20","P28","P36","P41","P57","P9","P010","P113","P169","P22","P2A","P37","P47","P58","P015","P11",
"P17","P23","P2B","P38", "P48", "P59","P017","P133","P182","P24","P30","P39A","P49","P5","P050","P138","P183","P25","P33",
"P39B","P4","P6"]

configfile: "/home/u1/knodele/Immunoediting_Human_cSCC/00_setup/somatic_mutation_calling_config.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_data/In_silico_muts/"
peptide_path = "/xdisk/khasting/knodele/Mayo_data/In_silico_muts/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_19.vcf"), sample=samples, peptide_path=peptide_path), # run pVACseq
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_19.peptides"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_19.peptides"), sample=samples, peptide_path=peptide_path) # Create WT peptide list

rule annotate_samples:
	input:
                os.path.join(vep_path, "{sample}_fake_mutations_vep.vcf")
	output:
                os.path.join(vep_path, "{sample}_fake_mutations_vep_annotated.vcf")
	params:
		sample_name = "{sample}"
	shell:
		"""
		vcf-genotype-annotator {input} {params.sample_name} "0/1" -o {output}
		"""

rule generate_fasta_19:
        input:
                os.path.join(vep_path, "{sample}_fake_mutations_vep_annotated.vcf")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_19.vcf")
        params:
                sample = "{sample}"
        shell:
                """
                python /xdisk/khasting/knodele/programs/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 9 {output} -s {params.sample};
                """

rule format_peptides_19:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_19.vcf")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_19.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """


rule wildtype_peptides_19:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_19.vcf")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_19.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>MT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """
