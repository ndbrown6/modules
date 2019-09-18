#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Extracting the results from bam-readcounts output
# usage: extract_readcounts_metrics.py readcount_output.txt 
# -- the results are print out to stdout

from sys import argv
# print(argv)
fields = "base:count:avg_mapping_quality:avg_basequality:avg_se_mapping_quality:num_plus_strand:num_minus_strand:avg_pos_as_fraction:avg_num_mismatches_as_fraction:avg_sum_mismatch_qualities:num_q2_containing_reads:avg_distance_to_q2_start_in_q2_reads:avg_clipped_length:avg_distance_to_effective_3p_end".split(":")

sample = argv[1].split('_')[0]

header = "\t".join(['sample', 'chrom', 'pos', 'ref', 'total_count'] + fields)
print(header)

with open(argv[1]) as f:
    for l in f:
        ls = l.strip().split()
        chrom = ls[0]
        pos = ls[1]
        ref = ls[2]
        total_count = ls[3]
        # not sure jwhat is ls[4] = library name?
        for d in ls[5:9]: # always in the order of ACGT
            # There are sometimes additional columns for insertion we can ignore
            ds = d.split(":")
            output = [sample, chrom, pos, ref, total_count] + ds[0:]
            print("\t".join(output))

        
