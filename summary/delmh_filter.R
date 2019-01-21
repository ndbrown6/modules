# delmh_filter.R : 
#     Filter delmh for jrflab deletion call critera (as in func comments).
#     input: tsv/all.somatic_indels.tsv , tsv/all.delmh_found.tsv
#     output: tsv/all.delmh_filtered.tsv

library(data.table)
rm(list=ls())

filter_deletion_jrflab  <- function(input) {
  # This deletion critera is the following:
    # Anything called by varscan and strelka keep it
    #   For long indels > 4 bases that are not "in frame" and called by "Platypus and scalpel" or "Platypus and lancet " keep it

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

  ## Filter indels by caller per Pier 
  del = del[ (variantCaller %like% 'varscan' & 
              variantCaller %like% 'strelka'   )   |
              (deletion_length > 4 & 
              (deletion_length %% 3) != 0 &
              variantCaller %like% 'scalpel' & 
              variantCaller %like% 'platypus') ]

  del = del[, original_columns, with=FALSE]
  return(del)
}

dels = fread("tsv/all.somatic_indels.tsv")
filtered_dels = filter_deletion_jrflab(dels) # this fiter can be tweaked

mh = fread("tsv/delmh_found.tsv")
filtered_mh = merge(filtered_dels, mh, 
    by=c("SAMPLE.TUMOR", 'SAMPLE.NORMAL', 'variantCaller', 
        'CHROM', 'POS', 'REF', 'ALT'))

fwrite(filtered_mh, 'tsv/delmh_filtered.tsv', sep="\t", na="")

