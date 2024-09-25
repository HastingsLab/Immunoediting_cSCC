#!/bin/bash
#SBATCH --job-name=CNVKit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate hatchet

python3 -m hatchet cluster-bins BB/bulk.bb -o BB/bulk.seg -O BB/bulk.bbc

python3 -m hatchet plot-bins -c RD --figsize 6,3 BB/bulk.bbc
python3 -m hatchet plot-bins -c CRD --figsize 6,3 BB/bulk.bbc
python3 -m hatchet plot-bins -c BAF --figsize 6,3 BB/bulk.bbc
python3 -m hatchet plot-bins -c BB BB/bulk.bbc
python3 -m hatchet plot-bins -c CBB BB/bulk.bbc -tS 0.01
