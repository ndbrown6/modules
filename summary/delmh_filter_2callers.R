# delmh_filter_2callers.R : 
#     Filter delmh for any deletions called by 2 callers (as in func comments).
#     input: tsv/all.somatic_indels.tsv , tsv/all.delmh_found.tsv
#     output: tsv/all.delmh_filtered.tsv

library(data.table)
rm(list=ls())

filter_deletion_2callers  <- function(input) {
  # This deletion critera is the following:
  #   - only keep deletions called by 2 callers
  #   - Note: actually jrflab modules already filter by 2 callers. This step actually only removes insertions - but it's good to explicitly filter thus.
  #
  # Following code tweaked extract_deletion to all modified selection critera
  d=input
  original_columns = names(d)
  d = input[variantCaller != "mutect"]
    d$indel_type = ifelse(nchar(d$ALT)< nchar(d$REF), "DEL", "INS")
    d$del_len = with(d, ifelse(indel_type=="DEL", nchar(REF)-nchar(ALT), NA))
    d$ins_len = with(d, ifelse(indel_type=="INS", nchar(ALT)-nchar(REF), NA))
    d$Read_Count = round(d$TUMOR_MAF*d$TUMOR_DP) # Not used

  ## Exploration for deletions and insertions
  del=d[nchar(ALT)<nchar(REF)]
  ins=d[nchar(ALT)>nchar(REF)] # not used
  ## Calculate deletion length
  del[, deletion_length:=nchar(REF)-nchar(ALT), ]

  count_caller_number = function(x) {
    splitted = strsplit(x, ',', fixed=T)
    return(length(splitted[[1]]))
  }

  del$caller_number = sapply(del$variantCaller, count_caller_number)

  ## Filter indels by caller per Pier 
  del = del[ caller_number>= 2 ]

  ## Only keep those final columns
  del = del[, original_columns, with=FALSE]
  return(del)
}

dels = fread("tsv/all.somatic_indels.tsv")
filtered_dels = filter_deletion_2callers(dels) # this fiter can be tweaked

mh = fread("tsv/delmh_found.tsv")
filtered_mh = merge(filtered_dels, mh, 
    by=c("SAMPLE.TUMOR", 'SAMPLE.NORMAL', 'variantCaller', 
        'CHROM', 'POS', 'REF', 'ALT'))

fwrite(filtered_mh, 'tsv/delmh_filtered.tsv', sep="\t", na="")

