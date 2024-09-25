import json
from collections import defaultdict
import os
import argparse

parser = argparse.ArgumentParser(description="Generate config files")
parser.add_argument("--fastq_path",required=True,help="Path to where all the fastqs are. For example: /data/CEM/shared/controlled_access/Beauty/")
parser.add_argument("--sample_info",required=True,help="Path to the sample info. For example: /scratch/tphung3/Cancer_Genomics/00_misc/samples_info.csv")
parser.add_argument("--ref_dir",required=True,help="Path to the directory where the references are. For example: /data/CEM/shared/public_data/references/1000genomes_GRCh38_reference_genome")
parser.add_argument("--ref_basename",required=True,help="Input the basename of the reference. For example: GRCh38_full_analysis_set_plus_decoy_hla")

args = parser.parse_args()

data = {}

# fastq path
data["fastq_path"] = args.fastq_path

# all sample ids

all_subjects = set()
all_DNA_names = set()
data["all_subjects"] = []
data["DNA_names"] = []
read_group_info = {}

with open(args.sample_info, "r") as f: #TODO: update the path here
	for line in f:
		items = line.rstrip("\n").split(",")
		all_subjects.add(items[2])
		sample=items[2]
		seq_name= items[3][:-9]
		all_DNA_names.add(seq_name)
		read_group_info[sample] = {"fq_1": items[3],
			"fq_2": items[4],
			"seq_name": seq_name,
			"ID": sample,
			"SM": sample,
			"LB": sample,
			"PU": sample,
			"PL": "Illumina"}
		data.update(read_group_info)		

for i in all_subjects:
	data["all_subjects"].append(i)

for i in all_DNA_names:
        data["DNA_names"].append(i)

# add path to reference
data["ref_dir"] = args.ref_dir
data["ref_basename"] = args.ref_basename

with open("somatic_mutation_calling_config.json", "w") as outfile:
	json.dump(data, outfile)

