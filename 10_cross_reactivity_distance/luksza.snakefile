# Setting up filesnames here:
from os.path import join
import os

samples = ["P001","P055","P13","P18","P26","P34","P3","P54","P7","P002","P062","P14","P19","P27","P35","P40","P55","P8","P004","P083","P164","P20","P28","P36","P41","P57","P9",
"P010","P113","P169","P22","P2A","P37","P47","P58","P015","P11","P17","P23","P2B","P38","P48","P59","P017","P133","P182","P24","P30","P39A","P49","P5","P050","P138","P183","P25",
"P33","P39B","P4","P6"]

#Paths
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/peptides/"
blast_path = "/xdisk/khasting/knodele/Mayo_human_data/blast_outputs/"
luksza_path = "/xdisk/khasting/knodele/Mayo_human_data/luksza_outputs/"

rule all:
    input:
#        expand(os.path.join(peptide_path, "{sample}_luksza_blast_input.txt"), sample=samples, peptide_path=peptide_path),
#        expand(os.path.join(blast_path, "{sample}_luksza_blast_iedb.xml"), sample=samples, blast_path=blast_path),
#        expand(os.path.join(luksza_path, "{sample}_luksza_R.txt"), sample=samples, luksza_path=luksza_path),
        expand(os.path.join("/xdisk/khasting/knodele/Mayo_data/Characteristics_tables/{sample}_all_characteristics_add_EC.csv"), sample=samples, luksza_path=luksza_path)

#rule blast_input:
#        input:
#                os.path.join(peptide_path, "{sample}_netctlpan.xsl")
#        output:
#                os.path.join(peptide_path, "{sample}_luksza_blast_input.txt")
#        shell:
#                """
#                cat {input} | sed '/Name/d' | awk '{{print ">"++count"|"$3"|MUT|"$2"\\n"$3}}' > {output}
#                """

#rule blast:
#        input:
#                os.path.join(peptide_path, "{sample}_luksza_blast_input.txt")
#        output:
#                os.path.join(blast_path, "{sample}_luksza_blast_iedb.xml")
#        shell:
#                """
#                blastp -query {input} -db /home/u1/knodele/programs/Luksza_programs/Input/iedb.fasta -outfmt 5 -evalue 100000000  -gapopen 11 -gapextend 1 > {output}
#                """

#rule calculate_R: 
#        input:
#                blast = os.path.join(blast_path, "{sample}_luksza_blast_iedb.xml"),
#                neoantigens = os.path.join(peptide_path, "{sample}_luksza_blast_input.txt")
#        output:
#                os.path.join(luksza_path, "{sample}_luksza_R.txt")
#        params:
#                dir = luksza_path
#        shell:
#                """
#                python /home/u1/knodele/programs/Luksza_programs/src/main_R_only.py {input.neoantigens} {params.dir} 26 4.8936 {output} {input.blast}
#                """

rule calculate_EC:
       input:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/Characteristics_tables/{sample}_peptides_kd_stab.txt")
       output:
                os.path.join("/xdisk/khasting/knodele/Mayo_data/Characteristics_tables/{sample}_all_characteristics_add_EC.csv")
       shell:
                """
                python /xdisk/khasting/knodele/programs/NeoantigenEditing/compute_EC.py --input {input} --output {output}
                """
