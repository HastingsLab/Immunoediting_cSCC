#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=600gb
#SBATCH --time=5:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

Rscript Compile_results_low_cell_num.R
