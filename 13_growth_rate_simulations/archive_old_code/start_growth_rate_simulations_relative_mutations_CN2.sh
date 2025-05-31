#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=42
#SBATCH --nodes=21
#SBATCH --mem=600gb
#SBATCH --time=40:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

for i in {1..42}
do
    Rscript Growth_simulations_relative_mutations_CN2.R $i &
done

wait
