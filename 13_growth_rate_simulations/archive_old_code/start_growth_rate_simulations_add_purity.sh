#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=42
#SBATCH --nodes=21
#SBATCH --mem=600gb
#SBATCH --time=40:00:00
#SBATCH --partition=windfall

source activate R_environment

for i in {1..42}
do
    Rscript Growth_simulations_add_purity.R $i &
done

wait
