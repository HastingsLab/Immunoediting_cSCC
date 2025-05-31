#!/bin/bash
#SBATCH --job-name=b1_prop
#SBATCH --ntasks=10
#SBATCH --nodes=10
#SBATCH --mem=500gb
#SBATCH --time=120:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

#for i in {1..5}
#do
#    Rscript Ratio_binding_mutations_in_silico.R $i &
#done

#wait

Rscript Ratio_binding_mutations_in_silico.R 47
