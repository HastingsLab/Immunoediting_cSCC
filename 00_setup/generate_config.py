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
all_patients = set()
all_samples = set()
all_DNA_names = set()
data["all_patients"] = []
data["all_samples"] = []
data["DNA_names"] = []
read_group_info = {}
tumor_normal_info = {}

with open(args.sample_info, "r") as f: #TODO: update the path here
	for line in f:
		items = line.rstrip("\n").split(",")
		all_patients.add(items[0])
		all_samples.add(items[1])
		all_samples.add(items[4])
		sample=items[1]
		seq_name= items[2][:-9]
		seq_name_2=items[3][:-9]
		all_DNA_names.add(seq_name)
		all_DNA_names.add(seq_name_2)
		read_group_info[sample] = {"fq_1": items[2],
			"fq_2": items[3],
			"seq_name": seq_name,
			"ID": sample,
			"SM": sample,
			"LB": sample,
			"PU": sample,
			"PL": "Illumina"}
		normal_sample=items[4]
		seq_name=items[5][:-9]
		seq_name_2=items[6][:-9]
		all_DNA_names.add(seq_name)
		all_DNA_names.add(seq_name_2)
		read_group_info[normal_sample] = {"fq_1": items[5],
			"fq_2": items[6],
			"seq_name": seq_name,
			"ID": normal_sample,
			"SM": normal_sample,
			"LB": normal_sample,
			"PU": normal_sample,
			"PL": "Illumina"}
		data.update(read_group_info)
		patient=items[0]
		tumor_normal_info[patient] = {"tumor": items[1], "normal": items[4]}		
		data.update(tumor_normal_info)

for i in all_patients:
        data["all_patients"].append(i)

for i in all_samples:
	data["all_samples"].append(i)

for i in all_DNA_names:
        data["DNA_names"].append(i)

# add path to reference
data["ref_dir"] = args.ref_dir
data["ref_basename"] = args.ref_basename

with open("somatic_mutation_calling_config.json", "w") as outfile:
	json.dump(data, outfile)

