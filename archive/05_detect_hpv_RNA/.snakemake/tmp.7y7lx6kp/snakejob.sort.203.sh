#!/bin/sh
# properties = {"type": "single", "rule": "sort", "local": false, "input": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC_map_map.bam", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC_unmapped.bam"], "output": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC_map_map.sort.bam", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC_unmapped.sort.bam"], "wildcards": {"sample": "CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC"}, "params": {}, "log": [], "threads": 1, "resources": {"tmpdir": "/tmp"}, "jobid": 203, "cluster": {}}
 cd /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA && \
/home/u1/knodele/miniconda3/envs/cancergenomics/bin/python3.7 \
-m snakemake /xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC_map_map.sort.bam --snakefile /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/extract_fastqs.snakefile \
--force --cores all --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files '/home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC_map_map.bam' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_306_T2a_B4_RNA.FCHMVH7BBXY_L7_IATTGTGAA-TGCATTGC_unmapped.bam' --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler ilp \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules sort --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /home/u1/knodele/miniconda3/envs/cancergenomics/bin \
--mode 2  --default-resources "tmpdir=system_tmpdir"  && touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/203.jobfinished || (touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/203.jobfailed; exit 1)

