# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P48","P47","P54","P58","P17","P19","P23","P25","P27","P28","P30","P34","P35","P36","P37",
"P38","P39A","P39B","P40","P41","P4","P5","P6","P7","P8","P9","P26","P24","P18","P59","P22","P20","P57",
"P55","P33","P49","P11","P13","P2A","P14","P2B","P3"]

configfile: "sample_id_config.json"

#Paths
vep_path = "/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/"
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/null_variant_calls/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_17.vcf"), sample=samples, peptide_path=peptide_path), # run pVACseq
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_17.peptides"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_17.peptides"), sample=samples, peptide_path=peptide_path) # Create WT peptide list

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

rule generate_fasta_17:
        input:
                os.path.join(vep_path, "{sample}_fake_mutations_vep_annotated.vcf")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_17.vcf")
        params:
                sample = lambda wildcards: config[wildcards.sample]["id"]
        shell:
                """
                python /xdisk/khasting/knodele/programs/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 8 {output} -s {params.sample};
                """

rule format_peptides_17:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_17.vcf")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_17.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """


rule wildtype_peptides_17:
        input:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_peptides_17.vcf")
        output:
                os.path.join(peptide_path, "{sample}_fake_mutations_vep_WT_17.peptides")
        shell:
                """
                cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>MT/d' | sed 's/MT.*ENST00/MT.ENST00/g' | sed 's/\./ /g' > {output}
                """
