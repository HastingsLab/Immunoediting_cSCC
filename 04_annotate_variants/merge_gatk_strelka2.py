import argparse
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument('--strelka', required=True,
    dest='strelka_input')
parser.add_argument('--gatk', required=True,
    dest='gatk_input')
parser.add_argument('--patient', required=True,
    dest='patient')
parser.add_argument('--outdir', required=True,
    dest='outdir')
args=parser.parse_args()

with open(args.strelka_input) as strelka_in, open(args.outdir + "/" + args.patient + "_strelka_table_with_IDs.txt",'w') as strelka_out:
    for line in strelka_in.readlines():
        if not (line.startswith("##")):
            if (line.startswith("#")):
                strelka_out.write(line.strip() + "\t" + "id" + "\n")
            else:
                split = line.split("\t")
                mutation_id = split[0] + "." + split[1] + "." + split[3] + "." + split[4]
                strelka_out.write(line.strip() + "\t" + mutation_id + "\n")
        else:
            continue

with open(args.gatk_input) as gatk_in, open(args.outdir + "/" + args.patient + "_gatk_table_with_IDs.txt",'w') as gatk_out:
    for line in gatk_in.readlines():
        if not (line.startswith("##")):
            if (line.startswith("#")):
                gatk_out.write(line.strip() + "\t" + "id" + "\n")
            else:
                split = line.split("\t")
                mutation_id = split[0] + "." + split[1] + "." + split[3] + "." + split[4]
                gatk_out.write(line.strip() + "\t" + mutation_id + "\n")
        else:
            continue

with open(args.outdir + "/" + args.patient + "_gatk_table_with_IDs.txt") as gatk_ids, open(args.outdir + "/" + args.patient + "_strelka_table_with_IDs.txt") as strelka_ids:
    gatk_table = pd.read_table(gatk_ids, sep="\t")
    strelka_table = pd.read_table(strelka_ids, sep="\t")
ids = gatk_table["id"].isin(strelka_table["id"])
intersection = gatk_table[ids]
intersection.to_csv(args.outdir + "/" + args.patient + "_gatk_strelka_intersection.txt", sep="\t", index=False)

