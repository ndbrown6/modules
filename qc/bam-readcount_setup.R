# Prepare list of chromosome location for bam-readcount
#    and setup the bash script to run bam-readcount on these regions

# https://github.com/genome/bam-readcount
# 
# input: 
    # tsv/all.mutect.tsv 
    # bam/ # folder where bam files are all linked

# output:
    # bam-readcount/region_tumor/
    # bam-readcount/region_normal/

    # running bam-readcount script:
    #     bam-readcount/run_bamreadcount_tumor.sh
    #     bam-readcount/run_bamreadcount_normal.sh
    #     script to check if the bam files to be used exist:
    #         bam-readcount/check_readcount_bam_files.sh

# Next step: actual calling of bam-readcount
    # The run ... script will be run project pipeline folder.

rm(list=ls())
library(data.table)
library(ipfun)

broad3 = fread("tsv/all.mutect.tsv")

save_readcount_region_tumor <- function(sample) {
    # Save the sample mutation region in the readcount/region folder, name by sample
    # ds = d[ TUMOR_SAMPLE == sample ]
    ds = broad3[ SAMPLE.TUMOR == sample ]
    mkdirp("bam-readcount/region_tumor/")
    ofile = paste0('bam-readcount/region_tumor/', sample, '.txt')
    fwrite(ds[, .(CHROM, POS, POS)], ofile, sep="\t", col.names=F)
}

save_readcount_region_normal <- function(sample) {
    # Save the sample mutation region in the readcount/region folder, name by sample
    # ds = d[ TUMOR_SAMPLE == sample ]
    ds = broad3[ SAMPLE.NORMAL == sample ]
    mkdirp("bam-readcount/region_normal/")
    ofile = paste0('bam-readcount/region_normal/', sample, '.txt')
    fwrite(ds[, .(CHROM, POS, POS)], ofile, sep="\t", col.names=F)
}

write_check_bam <- function(data=broad3) {
    # Generate checking script to see if bam file exsit
    # -- this is prep script to see if all bam files are correctly linked
    sink('bam-readcount/check_readcount_bam_files.sh')
    writeLines(paste0('ls ../bam/', unique(data$SAMPLE.TUMOR), '.bam'))
    sink()
}

write_run_tumor_bamreadcount <- function(data=broad3) {
    # Generating running script for bam-readcout
    # TODO: the reference fasta should come from the pipeline ideally,
    # not hard-specified here
    usample = unique(data$SAMPLE.TUMOR)
    mkdirp("bam-readcount/readcount_tumor")
    sink('run_bamreadcount_tumor.sh')
    writeLines(paste0('bam-readcount -w 0 ./bam/', usample,
        '.bam  -f /home/peix/share/reference/b37_dmp/b37.fasta -l ', 
        'bam-readcount/region_tumor/', usample, '.txt > ', 
        'bam-readcount/readcount_tumor/', usample, '_readcout.txt'))
    sink()
}

write_run_normal_bamreadcount <- function(data=broad3) {
    # Generating running script for bam-readcout
    usample = unique(data$SAMPLE.NORMAL)
    mkdirp("bam-readcount/readcount_normal")
    sink('run_bamreadcount_normal.sh')
    writeLines(paste0('bam-readcount -w 0 ./bam/', usample,
        '.bam  -f /home/peix/share/reference/b37_dmp/b37.fasta -l ', 
        'bam-readcount/region_normal/', usample, '.txt > ', 
        'bam-readcount/readcount_normal/', usample, '_readcout.txt'))
    sink()
}

main <- function() {
    # The main function is to 
    lapply(unique(broad3$SAMPLE.TUMOR), save_readcount_region_tumor)
    lapply(unique(broad3$SAMPLE.NORMAL), save_readcount_region_normal)
    write_check_bam()
    write_run_tumor_bamreadcount()
    write_run_normal_bamreadcount()
}

main()
