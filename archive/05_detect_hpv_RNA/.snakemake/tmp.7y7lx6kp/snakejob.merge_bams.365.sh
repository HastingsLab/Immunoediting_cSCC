#!/bin/sh
# properties = {"type": "single", "rule": "merge_bams", "local": false, "input": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_unmap_map.bam", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_map_unmap.bam", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_unmap_unmap.bam"], "output": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_unmapped.bam"], "wildcards": {"sample": "CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC"}, "params": {}, "log": [], "threads": 1, "resources": {"tmpdir": "/tmp"}, "jobid": 365, "cluster": {}}
 cd /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA && \
/home/u1/knodele/miniconda3/envs/cancergenomics/bin/python3.7 \
-m snakemake /xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_unmapped.bam --snakefile /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/extract_fastqs.snakefile \
--force --cores all --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files '/home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_unmap_map.bam' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_map_unmap.bam' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_7_RNA.FCHWLHCBBXX_L1_IGGCTAC_unmap_unmap.bam' --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler ilp \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules merge_bams --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /home/u1/knodele/miniconda3/envs/cancergenomics/bin \
--mode 2  --default-resources "tmpdir=system_tmpdir"  && touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/365.jobfinished || (touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/365.jobfailed; exit 1)

