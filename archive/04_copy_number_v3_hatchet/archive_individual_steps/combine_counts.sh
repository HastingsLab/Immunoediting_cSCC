#!/bin/bash
#SBATCH --job-name=CNVKit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate hatchet

python3 -m hatchet combine-counts -A read_counts -t read_counts/total.tsv -b P1tumor.1bed -o BB/bulk.bb -V hg38
