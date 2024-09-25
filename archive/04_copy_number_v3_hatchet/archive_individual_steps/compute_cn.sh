#!/bin/bash
#SBATCH --job-name=CNVKit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate hatchet

export HATCHET_COMPUTE_CN_SOLVER=cbc

python3 -m hatchet compute-cn -i BB/bulk -n2,6 -p 400 -u 0.03 -r 100 

python3 -m hatchet plot-cn best.bbc.ucn
