# Setting up filesnames here:
from os.path import join
import os

#Sample IDs
samples = ["P11", "P13", "P14", "P16", "P17", "P18", "P19", "P20", "P22", "P23", "P24", "P25", "P26", "P27", "P28",
"P2A", "P2B", "P30", "P33", "P34", "P35", "P36", "P37", "P38", "P39A", "P39B", "P3", "P40", "P41", "P47", "P48", "P49", "P4",
"P54", "P55", "P57", "P58", "P59", "P5", "P7", "P8", "P9", "P6"]
#samples = ["P1"]

#Paths
peptide_path = "/xdisk/khasting/knodele/Mayo_human_data/peptides/"
blast_path = "/xdisk/khasting/knodele/Mayo_human_data/blast_outputs/"
luksza_path = "/xdisk/khasting/knodele/Mayo_human_data/luksza_outputs/"

rule all:
    input:
        expand(os.path.join(peptide_path, "{sample}_luksza_blast_input.txt"), sample=samples, peptide_path=peptide_path),
        expand(os.path.join(blast_path, "{sample}_luksza_blast_iedb.xml"), sample=samples, blast_path=blast_path),
        expand(os.path.join(luksza_path, "{sample}_luksza_R.txt"), sample=samples, luksza_path=luksza_path),
        expand(os.path.join(luksza_path, "{sample}_all_characteristics_add_EC.csv"), sample=samples, luksza_path=luksza_path)

rule blast_input:
        input:
                os.path.join(peptide_path, "{sample}_netctlpan.xsl")
        output:
                os.path.join(peptide_path, "{sample}_luksza_blast_input.txt")
        shell:
                """
                cat {input} | sed '/Name/d' | awk '{{print ">"++count"|"$3"|MUT|"$2"\\n"$3}}' > {output}
                """

rule blast:
        input:
                os.path.join(peptide_path, "{sample}_luksza_blast_input.txt")
        output:
                os.path.join(blast_path, "{sample}_luksza_blast_iedb.xml")
        shell:
                """
                blastp -query {input} -db /home/u1/knodele/programs/Luksza_programs/Input/iedb.fasta -outfmt 5 -evalue 100000000  -gapopen 11 -gapextend 1 > {output}
                """

rule calculate_R: 
        input:
                blast = os.path.join(blast_path, "{sample}_luksza_blast_iedb.xml"),
                neoantigens = os.path.join(peptide_path, "{sample}_luksza_blast_input.txt")
        output:
                os.path.join(luksza_path, "{sample}_luksza_R.txt")
        params:
                dir = luksza_path
        shell:
                """
                python /home/u1/knodele/programs/Luksza_programs/src/main_R_only.py {input.neoantigens} {params.dir} 26 4.8936 {output} {input.blast}
                """

rule calculate_EC:
       input:
                os.path.join(luksza_path, "{sample}_all_characteristics.csv")
       output:
                os.path.join(luksza_path, "{sample}_all_characteristics_add_EC.csv")
       shell:
                """
                python /home/u1/knodele/programs/NeoantigenEditing/compute_EC.py {input} {output}
                """
