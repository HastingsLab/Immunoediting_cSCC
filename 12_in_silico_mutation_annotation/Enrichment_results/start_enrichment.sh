#!/bin/bash
#SBATCH --job-name=b1_enrich
#SBATCH --ntasks=100
#SBATCH --nodes=10
#SBATCH --mem=1000gb
#SBATCH --time=48:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting

source activate R_environment

Rscript Enrichment_score_calculation_p1.R 2

#for i in {1..100}
#do
#    Rscript Enrichment_score_calculation.R 52 $i &
#done
#
#wait

#Rscript Enrichment_score_calculation.R 1

