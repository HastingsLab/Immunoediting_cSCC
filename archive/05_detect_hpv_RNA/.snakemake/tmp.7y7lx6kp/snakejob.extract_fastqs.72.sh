#!/bin/sh
# properties = {"type": "single", "rule": "extract_fastqs", "local": false, "input": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_map_map.sort.bam", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_unmapped.sort.bam"], "output": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_mapped.1.fastq", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_mapped.2.fastq", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_unmapped.1.fastq", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_unmapped.2.fastq"], "wildcards": {"sample": "167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG"}, "params": {}, "log": [], "threads": 1, "resources": {"tmpdir": "/tmp"}, "jobid": 72, "cluster": {}}
 cd /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA && \
/home/u1/knodele/miniconda3/envs/cancergenomics/bin/python3.7 \
-m snakemake /xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_mapped.1.fastq --snakefile /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/extract_fastqs.snakefile \
--force --cores all --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files '/home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_map_map.sort.bam' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/167-T2a_B2_RNA.FCHFHK5BBXY_L2_ICGTACG_unmapped.sort.bam' --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler ilp \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules extract_fastqs --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /home/u1/knodele/miniconda3/envs/cancergenomics/bin \
--mode 2  --default-resources "tmpdir=system_tmpdir"  && touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/72.jobfinished || (touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/72.jobfailed; exit 1)

