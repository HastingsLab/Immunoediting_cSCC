#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=800gb
#SBATCH --time=40:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

for i in {1..42}
do
    Rscript Ratio_binding_mutations_in_silico.R $i &
done

wait
