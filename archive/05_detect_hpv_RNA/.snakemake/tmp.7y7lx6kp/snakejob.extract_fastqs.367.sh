#!/bin/sh
# properties = {"type": "single", "rule": "extract_fastqs", "local": false, "input": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_map_map.sort.bam", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_unmapped.sort.bam"], "output": ["/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_mapped.1.fastq", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_mapped.2.fastq", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_unmapped.1.fastq", "/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_unmapped.2.fastq"], "wildcards": {"sample": "CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC"}, "params": {}, "log": [], "threads": 1, "resources": {"tmpdir": "/tmp"}, "jobid": 367, "cluster": {}}
 cd /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA && \
/home/u1/knodele/miniconda3/envs/cancergenomics/bin/python3.7 \
-m snakemake /xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_mapped.1.fastq --snakefile /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/extract_fastqs.snakefile \
--force --cores all --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files '/home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_map_map.sort.bam' '/xdisk/khasting/knodele/Mayo_data/RNA_primary_bams/CSCC_8_RNA.FCHWLHCBBXX_L1_IGTGGCC_unmapped.sort.bam' --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler ilp \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules extract_fastqs --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /home/u1/knodele/miniconda3/envs/cancergenomics/bin \
--mode 2  --default-resources "tmpdir=system_tmpdir"  && touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/367.jobfinished || (touch /home/u1/knodele/Immunoediting_Human_cSCC/archive/05_detect_hpv_RNA/.snakemake/tmp.7y7lx6kp/367.jobfailed; exit 1)

