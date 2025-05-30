#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting


#source activate vep_env
source activate cancergenomics
#source activate pvacseq_env

#module load bcftools-1.14-gcc-11.2.0

snakemake --snakefile polysolver_hla_typing.snakefile -j 50 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --mem=30gb -t 4:00:00"

