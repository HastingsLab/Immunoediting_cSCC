#!/bin/bash
#SBATCH --job-name=VEP
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=30gb
#SBATCH --time=96:00:00
#SBATCH --partition=standard
#SBATCH --account=khasting


#source activate vep_env
source activate hlahd
#source activate pvacseq_env

#module load bcftools-1.14-gcc-11.2.0
PATH=$PATH:/xdisk/khasting/knodele/programs/hlahd.1.7.1/bin
snakemake --snakefile hlahd_hla_typing.snakefile -j 50 --keep-target-files --rerun-incomplete --cluster "sbatch --partition=standard --account=khasting -n 1 -c 1 --ntasks=10 --mem=30gb -t 24:00:00"

