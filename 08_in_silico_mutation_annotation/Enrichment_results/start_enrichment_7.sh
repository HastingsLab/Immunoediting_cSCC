#!/bin/bash
#SBATCH --job-name=CNVkit
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=800gb
#SBATCH --time=10:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

#for i in {1..42}
#do
#    Rscript Enrichment_score_calculation.R $i &
#done
#
#wait

Rscript Enrichment_score_calculation.R 41
