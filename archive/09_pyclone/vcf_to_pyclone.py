import vcf
import pandas as pd
import sys
import math

def process_vcf_cnvkit_files(vcf_file, cnvkit_file, output_file):
    vcf_reader = vcf.Reader(open(vcf_file, 'r'))
    cnvkit_data = pd.read_csv(cnvkit_file, sep='\t')

    results = []
    
    index_counter = 0
    for record in vcf_reader:
        total_read_count = record.INFO.get('DP', '')
        allelic_frequency = record.INFO.get('AF', '')[0]
        variant_read_count = int(total_read_count * float(allelic_frequency))
        normal_read_count = total_read_count - variant_read_count

        chromosome = record.CHROM
        print(chromosome)
        position = record.POS
        variant_id = chromosome + ":" +  str(position)
        #print(variant_id)
        cnvkit_line = cnvkit_data[(cnvkit_data['chromosome'] == chromosome) & (cnvkit_data['start'] <= position) & (position <= cnvkit_data['end'])]
        #print(cnvkit_line)
        
        if not cnvkit_line.empty:
             normal_cn = float(cnvkit_line['cn'])            
             cn1 = cnvkit_line['cn1']
             cn2 = cnvkit_line['cn2']
             if float(cn2)>float(cn1):
                  major_cn = float(cn2)
                  minor_cn = float(cn1)
             else:
                  major_cn = float(cn1)
                  minor_cn = float(cn2)

             if not math.isnan(cn1) and not math.isnan(cn2):
                  results.append([variant_id, normal_read_count, variant_read_count, normal_cn, minor_cn, major_cn])
                  #print(results)
                  index_counter += 1
             else:
                  print("No CN data")
        else:
             print("No matching entry found")

    output_df = pd.DataFrame(results, columns=['mutation_id','ref_counts', 'var_counts', 'normal_cn', 'minor_cn', 'major_cn'])
    output_df.to_csv(output_file, sep='\t', index=False)

# Example usage:
process_vcf_cnvkit_files(sys.argv[1], sys.argv[2], sys.argv[3])
