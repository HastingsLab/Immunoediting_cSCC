#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=1:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

Rscript Compile_results.R
