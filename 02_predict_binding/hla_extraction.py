import json
from collections import defaultdict
import os
import argparse
import re

parser = argparse.ArgumentParser(description="Generate config files")
parser.add_argument("--sample", required=True, help="sample to extract HLA types")
parser.add_argument("--subject", required=True, help="patient id to save data under")
parser.add_argument("--outfile", required=True, help="file to write output to")

args = parser.parse_args()

data={}

os.chdir('/xdisk/khasting/knodele/Mayo_human_data/hla_types')

hla=[]
dir_name = "/xdisk/khasting/knodele/Mayo_human_data/hla_types/"+args.sample
os.chdir(dir_name)
with open("winners.hla.txt", "r") as f:
	for line in f:
		if line.startswith("HLA-A"):
			items = line.split("\t")
			hla_1 = items[1].split("_")
			hla_1_final = "HLA-A*" + hla_1[2] + ":" + hla_1[3] 
			hla.append(hla_1_final)
			hla_2 = items[2].split("_")
			hla_2_final = "HLA-A*" + hla_2[2] + ":" + hla_2[3]
			hla.append(hla_2_final)
		if line.startswith("HLA-B"):
			items = line.split("\t")
			hla_1 = items[1].split("_")
			hla_1_final = "HLA-B*" + hla_1[2] + ":" + hla_1[3]
			hla.append(hla_1_final)
			hla_2 = items[2].split("_")
			hla_2_final = "HLA-B*" + hla_2[2] + ":" + hla_2[3]
			hla.append(hla_2_final)
		if line.startswith("HLA-C"):
			items = line.split("\t")
			hla_1 = items[1].split("_")
			hla_1_final = "HLA-C*" + hla_1[2] + ":" + hla_1[3]
			hla.append(hla_1_final)
			hla_2 = items[2].split("_")
			hla_2_final = "HLA-C*" + hla_2[2] + ":" + hla_2[3]
			hla.append(hla_2_final)
hla = ",".join(hla)
data[args.subject]={"hla":hla}

os.chdir('/xdisk/khasting/knodele/Mayo_human_data/hla_types')
with open(args.outfile, "w") as outfile:
	json.dump(data, outfile)
