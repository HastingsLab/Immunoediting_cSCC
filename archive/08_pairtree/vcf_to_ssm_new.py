import vcf
import pandas as pd
import sys
import math

def calculate_variant_probability(variant_copy_number, reference_copy_number):
    total_copy_number = variant_copy_number + reference_copy_number
    return float(variant_copy_number / total_copy_number) if total_copy_number != 0 else 0

def process_vcf_cnvkit_files(vcf_file, cnvkit_file, output_file):
    vcf_reader = vcf.Reader(open(vcf_file, 'r'))
    cnvkit_data = pd.read_csv(cnvkit_file, sep='\t')

    results = []
    
    index_counter = 0
    for record in vcf_reader:
        variant_id = f"s{index_counter}"
        #print(record.INFO)
        variant_name = f"s{index_counter}"
        total_read_count = record.INFO.get('DP', '')
        allelic_frequency = record.INFO.get('AF', '')[0]
        variant_read_count = int(total_read_count * float(allelic_frequency))


        chromosome = record.CHROM
        print(chromosome)
        position = record.POS
        #print(position)
        cnvkit_line = cnvkit_data[(cnvkit_data['chromosome'] == chromosome) & (cnvkit_data['start'] <= position) & (position <= cnvkit_data['end'])]
        #print(cnvkit_line)
        
        if not cnvkit_line.empty:
             variant_copy_number = cnvkit_line['cn2']
             #variant_read_probability = float(cnvkit_line['baf'])
             print(variant_copy_number)
             reference_copy_number = cnvkit_line['cn1']
             print(reference_copy_number)
             variant_read_probability = calculate_variant_probability(float(variant_copy_number), float(reference_copy_number))
             print(variant_read_probability)
             if not math.isnan(variant_read_probability) and not variant_read_probability==0.0:
                  results.append([variant_id, variant_name, variant_read_count, total_read_count, variant_read_probability])
                  index_counter += 1
             else:
                  print("No CN data")
        else:
             print("No matching entry found")

    output_df = pd.DataFrame(results, columns=['id', 'name', 'var_reads', 'total_reads', 'var_read_prob'])
    output_df.to_csv(output_file, sep='\t', index=False)

# Example usage:
process_vcf_cnvkit_files(sys.argv[1], sys.argv[2], sys.argv[3])
