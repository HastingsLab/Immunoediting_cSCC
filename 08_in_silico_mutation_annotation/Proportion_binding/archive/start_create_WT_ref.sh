#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=600gb
#SBATCH --time=40:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

Rscript Create_WT_reference_in_silico_mutations.R
